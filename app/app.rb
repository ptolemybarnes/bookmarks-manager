require 'data_mapper'
require 'sinatra/base'
require 'byebug'
require 'rack-flash'
require_relative 'data_mapper_setup'
require_relative './helpers/app_helpers'

class BookmarkManager < Sinatra::Base
  use Rack::Flash
  use Rack::MethodOverride
  include ApplicationHelpers

  enable :sessions
  set :session_secret, 'super_secret'

# CREATE / VIEW BOOKMARKS

  get '/' do
    @links = Link.all
    erb :index, :layout => :layout
  end

  post '/links' do
    url   = params["url"]
    title = params["title"]
    tag   = params["tags"].split(" ").map do |tag|
      Tag.first_or_create(:text => tag)
    end
    Link.create(:url => url, :title => title, :tags => tag)
    redirect to('/')
  end

  get '/tags/:text' do
    tag    = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

# CREATION OF NEW USER

  get '/users/new' do
    @user = User.new
    erb :"users/new"
  end

  post '/users' do
    @user = User.create(:email                 => params[:email],
                        :password              => params[:password],
                        :password_confirmation => params[:password_confirmation])
    
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

# SIGN IN EXISTING USER

  get '/sessions/new' do
    erb :"sessions/new"
  end

  delete '/sessions/:email' do
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





