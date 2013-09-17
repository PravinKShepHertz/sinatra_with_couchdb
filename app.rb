require 'sinatra'
require 'couchrest_model'
require 'net/http'
require 'open-uri'

class User < CouchRest::Model::Base
  property :name, String
  property :email, String
  property :desc, String
end


helpers do
  def link_to(url,text=url,opts={})
    attributes = ""
	opts.each { |key,value| attributes << key.to_s << "=\"" << value << "\" "}
	"<a href=\"#{url}\" #{attributes}>#{text}</a>"
  end

  def delete_user_button(user_id)
    erb :_delete_user_button, locals: { user_id: user_id}
  end
end

# Get all of our routes
get '/' do
  @users = User.all
  erb :'users/index'
end

# Get the New User form
get '/new' do
  @user = User.new
  erb :'users/new'
end

post '/user' do
  User.create(:name => params[:name], :email => params[:email], :desc => params[:desc])
  @users = User.all
  erb :'users/index'
end

# Deletes the user with this ID and redirects to homepage.
delete "/user/:id" do
  @user = User.find(params[:id]).destroy
  redirect "/"
end