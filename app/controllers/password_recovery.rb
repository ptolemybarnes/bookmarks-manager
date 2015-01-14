class BookmarkManager < Sinatra::Base

  get '/users/password_recovery' do
    erb :"users/password_recovery"
  end

  post '/users/password_recovery' do
    puts User.all
    user = User.first(params[:email] => email)
    user.password_token = (1..64).map { ('A'..'Z').to_a.sample }.join
    user.password_token_timestamp = Time.now
    user.save
  end

  get '/users/password_recovery/:token' do
    user = User.first( :password_token => token )
  end

end