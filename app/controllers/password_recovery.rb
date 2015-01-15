require 'rest_client'

class BookmarkManager < Sinatra::Base

  get '/users/password_recovery' do
    erb :"users/password_recovery"
  end

  post '/users/password_recovery' do
    puts User.all
    user = User.first(:email => params[:email])
    user.password_token = (1..64).map { ('A'..'Z').to_a.sample }.join
    user.password_token_timestamp = Time.now
    user.save
    send_recovery_email_to user
    redirect to('/')
  end

  get '/users/password_recovery/:token' do
    user = User.first( :password_token => params[:token] )
    "Hello," + user.email
  end

  helpers do

    def send_recovery_email_to user
      api_key = ENV['MAILGUN_API_KEY']
      api_url = "https://api:#{api_key}@api.mailgun.net/v2/app33254319.mailgun.org"
      
      RestClient.post api_url + "/messages",
          :from    => "postmaster@app33254319.mailgun.org",
          :to      => user.email,
          :subject => "Password Recovery",
          :text    => '/users/password_recovery/' + user.password_token
    end

  end

end