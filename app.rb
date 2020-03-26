# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "time"
require_relative "lib/memo"

enable :method_override

before do
  @app_name = "MEMO"
end

# Show Top Page
get "/" do
  @index = Memo.index.sort_by { |m| m[:updated_at] }.reverse
  @page_name = ""
  erb :top
end

# Create Item
post "/" do
  Memo.create(params[:text])
  redirect "/"
end

# Show New Page
get "/new" do
  @page_name = "New"
  erb :new
end

# Show Edit Page
get %r{/(\d+)/edit} do |id|
  @memo = Memo.show(id) || halt(404)
  @page_name = "Edit"
  erb :edit
end

# Show Item
get %r{/(\d+)} do |id|
  @memo = Memo.show(id) || halt(404)
  @page_name, * = @memo.text.partition("\n")
  erb :show
end

# Update
patch %r{/(\d+)} do |id|
  Memo.update(id, params[:text])
  redirect "/"
end

# Delete Item
delete %r{/(\d+)} do |id|
  Memo.destroy(id)
  redirect "/"
end

# 404
not_found do
  @page_name = "404: Page not found."
  @error_title = "404"
  @error_massage = "Page not found."
  erb :error
end

# 500
error do
  @page_name = "500: Unexpecte error."
  @error_title = "500"
  @error_massage = "Unexpecte error."
  erb :error
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
  def hbr(text)
    h(text).gsub(/\R/, "<br>")
  end
  def ellipsis(text, length = 24)
    text.size > length ? text.slice(0, length) + "..." : text
  end
  def ft(time)
    n = Time.now
    t = Time.parse(time.to_s)
    if t.day == n.day && n - t < 60 * 60
      ((n - t).to_i / 60).to_s + "m ago"
    elsif t.day == n.day && n - t < 60 * 60 * 24
      time.strftime("%H:%M")
    else
      time.strftime("%Y/%m/%d")
    end
  end
end
