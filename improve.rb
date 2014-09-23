require "data_mapper"
require "dm-core"
require "dm-migrations"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Improve
  include DataMapper::Resource
  property :id,              Serial
  property :header,          String
  property :bodyimprove,     Text
  property :section,         Integer
  property :showroom_index,  Integer

end

DataMapper.finalize
DataMapper.auto_upgrade!

module ImproveHelpers 

  def show_improves
    @improve = Improve.all
  end

  def create_improve
    @new_improve = Improve.create(params[:improve])
  end

end

helpers ImproveHelpers

post '/create_improve' do 
  if create_improve
    redirect to ("/improve")
  end
end

get '/improve' do
  env['warden'].authenticate!
  @current_user = env['warden'].user
  @username = @current_user.username
  show_improves
  slim :'admin/improve', :layout => :'admin/admin_layout'
end

get '/improve/:id' do
  @sale = Improve.get(params[:id])
end

delete '/improve/:id' do 
  Improve.get(params[:id]).destroy
  redirect to ("/improve")
end


