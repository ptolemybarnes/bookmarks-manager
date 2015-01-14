require 'data_mapper'
require 'sinatra/base'
require 'byebug'
require 'sinatra/partial'
require 'rack-flash'
require_relative 'data_mapper_setup'
require_relative './controllers/init'
require_relative './helpers/app_helpers'

class BookmarkManager < Sinatra::Base
  set :root, File.dirname(__FILE__) # sets app/. as the default route.
  use Rack::Flash
  use Rack::MethodOverride
  
  include ApplicationHelpers

  enable :sessions
  set :session_secret, 'super_secret'

  configure do
    register Sinatra::Partial
    set :partial_template_engine, :erb
  end

end





