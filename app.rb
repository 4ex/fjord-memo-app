require 'sinatra'
require 'sinatra/reloader'

APP_NAME = "Memo"

class Memo
  attr_reader :id
  
  def initialize(id)
    @id = id
  end
  def text
    self.class.read(id)
  end

  class << self
    def index
      index = {}
      data_files.each do |f|
        index[to_id(f)] = File.open(f){|f| f.gets}
      end
      index
    end
    def create(text)
      File.open(to_path(latest_id + 1), "w") {|f| f.puts(text)}
    end
    def read(id)
      File.open(to_path(id), "r") {|f| f.read}
    end
    def update(id, text)
      File.open(to_path(id), "w") {|f| f.puts(text)}
    end
    def delete(id)
      File.delete(to_path(id))
    end

    private
    def data_files
      Dir.glob("data/[0-9]*.txt")
    end
    def latest_id
      data_files.map{|f| to_id(f)}.max || 0
    end
    def to_path(id)
      "data/#{id}.txt"
    end
    def to_id(path)
      path.slice(/[0-9]+/).to_i
    end
  end
end

enable :method_override

before do
  @app_name = APP_NAME
end

# Show Top Page
get '/' do
  @title = APP_NAME
  @index = Memo.index
  erb :top
end

# Create Item
post '/' do
  Memo.create(params[:text])
  redirect '/'
end

# Show New Page
get '/new' do
  @title = "New Memo - #{APP_NAME}"
  erb :new
end

# Show Edit Page
get "/*/edit" do |id|
  @title = "Edit #{id} - #{APP_NAME}"
  @memo = Memo.new(id)
  erb :edit
end

# Show Item
get '/*' do |id|
  @title = "Show #{id} - #{APP_NAME}"
  @memo = Memo.new(id)
  erb :show
end

# Update
patch "/*" do |id|
  Memo.update(id, params[:text])
  redirect "/#{id}"
end

# Delete Item
delete "/*" do |id|
  Memo.delete(id)
  redirect "/"
end
