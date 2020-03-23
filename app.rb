require 'sinatra'
require 'sinatra/reloader'
require_relative 'lib/memo'

APP_NAME = "Memo"

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
get %r{/([0-9]*)/edit} do |id|
  @title = "Edit #{id} - #{APP_NAME}"
  @memo = Memo.new(id)
  erb :edit
end

# Show Item
get %r{/([0-9]*)} do |id|
  @title = "Show #{id} - #{APP_NAME}"
  @memo = Memo.new(id)
  erb :show
end

# Update
patch %r{/([0-9]*)} do |id|
  Memo.update(id, params[:text])
  redirect "/"
end

# Delete Item
delete %r{/([0-9]*)} do |id|
  Memo.delete(id)
  redirect "/"
end
