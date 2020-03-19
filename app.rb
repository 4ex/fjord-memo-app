require 'sinatra'
require 'sinatra/reloader'

app_name = "Memo App"

# Top
get '/' do
  @title = app_name
  erb :top
end

# New
get '/new' do
  @title = "New Memo - #{app_name}"
  erb :new
end

# Edit
get "/*/edit" do |id|
  @title = "Edit #{id} - #{app_name}"
  @id = id
  erb :edit
end

# Show
get '/*' do |id|
  @title = "Show #{id} - #{app_name}"
  @id = id
  erb :show
end
