require "data_mapper"
require "dm-core"
require "dm-migrations"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Sales
  include DataMapper::Resource
  property :id,              Serial
  property :header,          String
  property :deadline,        String
  property :bodysale,        Text
  property :showroom_index,  Integer
end

DataMapper.finalize
DataMapper.auto_upgrade!

module SalesHelpers 

  def show_sales
    @sales = Sales.all
  end

  def create_sale
    @new_sale = Sales.create(params[:sales])
  end

end

helpers SalesHelpers

post '/create_sales' do 
  if create_sale
    redirect to ("/sales")
  end
end

get '/sales' do
  env['warden'].authenticate!
  @current_user = env['warden'].user
  @username = @current_user.username
  show_sales
  slim :'admin/sales', :layout => :'admin/admin_layout'
end

get '/sales/:id' do
  @sale = Sales.get(params[:id])
end

delete '/sales/:id' do 
  Sales.get(params[:id]).destroy
  redirect to ("/sales")
end


