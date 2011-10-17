DataMapper.setup(:default, {
  :adapter => 'sqlite3',
  :host => 'localhost',
  :username => '',
  :password => '',
  :database => 'db/images.db'
})

class Image
  include DataMapper::Resource
  
  property :id,           Serial
  property :path,         String
  property :posted_by,    String
  property :caption,      String
  property :created_at,   DateTime
  
  def formatted_created_at
    self.created_at.strftime(self.time_format_string)
  end
  
  def s3_filename
    "weddingImage_#{self.id}.jpg"
  end
  
  def s3_url
    "https://s3.amazonaws.com/WeddingImages/#{s3_filename}"
  end
end

DataMapper.auto_upgrade!
#DataMapper.auto_migrate!

  
  