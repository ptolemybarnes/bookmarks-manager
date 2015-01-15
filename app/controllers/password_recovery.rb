class BookmarkManager < Sinatra::Base

  helpers Sinatra::UrlForHelper

  get '/users/password_recovery' do
    erb :"users/password_recovery"
  end

  post '/users/password_recovery' do
    user = User.first(:email => params[:email])
    token = (1..64).map { ('A'..'Z').to_a.sample }.join

    user.update(password_token: token, password_token_timestamp: Time.now)
    recovery_url = url_for("/users/password_recovery/#{user.password_token}", :full)

    email = {
      subject: "Password Recovery",
      message: "Follow this link to reset your password: #{recovery_url}"
    }

    send_email_to user, email
    redirect to('/')
  end

  get '/users/password_recovery/:token' do
    @user = User.first( :password_token => params[:token] )
    @token= params[:token]
    erb :"users/reset_password"
  end

  post '/users/reset_password' do
    @user = User.first( :password_token => params[:token] )
    byebug
    if User.update(:password              => params[:password], :password_confirmation => params[:password_confirmation])
       session[:user_id] = @user.id
       redirect to('/')
    else
       "#{@user.errors.full_messages}"
    end
  end

end