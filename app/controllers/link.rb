class BookmarkManager < Sinatra::Base

  post '/links' do
    url   = params["url"]
    title = params["title"]
    tag   = params["tags"].split(" ").map do |tag|
      Tag.first_or_create(:text => tag)
    end
    Link.create(:url => url, :title => title, :tags => tag)
    redirect to('/')
  end



end