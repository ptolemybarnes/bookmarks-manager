# this class corresponds to a link table in the database?
class Link

  include DataMapper::Resource

  # This block describes what resources our model will have
  property :id,     Serial # Serial means that it will be auto-incremented for every record
  property :title,  String
  property :url,    String

  has n, :tags, :through => Resource

end