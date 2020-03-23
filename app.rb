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
      Dir.glob("data/[0-9]*.txt").each{|f| index[f.slice(/[0-9]+/).to_i] = File.open(f){|f| f.readline}}
      index
    end
    def create(text)
      File.open("data/#{latest_id + 1}.txt", "w") {|f| f.puts(text)}
    end
    def read(id)
      File.open("data/#{id}.txt", "r") {|f| f.read}
    end
    def update(id, text)
      File.open("data/#{id}.txt", "w") {|f| f.puts(text)}
    end
    def delete(id)
      File.delete("data/#{id}.txt")
    end
    private
    def latest_id
      Dir.glob("[0-9]*.txt", base: "data").map{|f| f.delete(".txt").to_i}.max || 0
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
