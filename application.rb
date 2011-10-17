require 'rubygems'
require 'bundler'
Bundler.require
require './models'

class Application < Sinatra::Base
  $config = YAML.load(File.read('./config/config.yml'))
  $aws_bucket = $config[:bucket]
  
  #set utf-8 for outgoing
  before do 
    headers "Content-Type" => "text/html; charset=utf-8"
    $rooturl = url('/')  
  end 
  
  get '/' do
    erb :front
  end
  
  get '/images' do
    @images = Image.all
    @bucket = $aws_bucket
    erb :images
  end
  
  get '/images/new' do
     @newurl = url('/images')
     erb :new_image
  end
  
  post '/images' do
    if params[:file]
      filename = params[:file][:filenmae]
      file = params[:file][:tempfile]
      
      @aws_access_key_id = $config[:access_key_id]
      @aws_secret_key = $config[:secret_access_key]
      @aws_bucket = $config[:bucket]
      
      AWS::S3::Base.establish_connection!(:access_key_id => @aws_access_key_id, :secret_access_key => @aws_secret_key)
      
      image = Image.create(
            :path => filename, 
            :caption => params[:caption], 
            :posted_by => params[:author], 
            :created_at => Time.now
            )
      
      AWS::S3::S3Object.store(image.s3_filename, open(file), @aws_bucket, :access => :public_read)
      
      
      
      "Image uploaded"
    else
      "You have to choose a file"
    end
  end

  #   404
  #---------------------------------------

  not_found do
    #erb :notfound
  end
  
end
