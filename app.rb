require 'sinatra'
require 'sinatra/reloader'

app_name = "Memo App"

# Top
get '/' do
  app_name
end

# Template
get '/template' do
  erb :template
end

# New
get '/new' do
  "New Memo - #{app_name}"
end

# Edit
get "/*/edit" do |id|
  "Edit #{id} - #{app_name}"
end

# Show
get '/*' do |id|
  "Show #{id} - #{app_name}"
end
