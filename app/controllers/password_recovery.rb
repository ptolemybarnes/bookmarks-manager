class BookmarkManager < Sinatra::Base

  helpers Sinatra::UrlForHelper

  get '/users/password_recovery' do
    erb :"users/password_recovery"
  end

  post '/users/password_recovery' do
    puts User.all
    user = User.first(:email => params[:email])
    user.password_token = (1..64).map { ('A'..'Z').to_a.sample }.join
    user.password_token_timestamp = Time.now
    user.save

    recovery_url = url_for("/users/password_recovery/#{user.password_token}", :full)

    email = {
      subject: "Password Recovery",
      message: "Follow this link to reset your password: #{recovery_url}"
    }

    send_email_to user, email
    redirect to('/')
  end

  get '/users/password_recovery/:token' do
    user = User.first( :password_token => params[:token] )
    "Hello," + user.email
  end

end