# SIGN IN EXISTING USER
class BookmarkManager < Sinatra::Base

  get '/sessions/new' do
    erb :"sessions/new"
  end

  delete '/sessions/:email' do
    session.clear
    "Good bye #{params[:email]}!"
  end

  post '/sessions' do
    email, password = params[:email], params[:password]
    user            = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
  end

end