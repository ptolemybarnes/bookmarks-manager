class BookmarkManager < Sinatra::Base

  get '/' do
    @links = Link.all
    erb :index, :layout => :layout
  end

end