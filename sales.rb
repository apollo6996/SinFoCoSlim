require "data_mapper"
require "dm-core"
require "dm-migrations"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Sales
  include DataMapper::Resource
  property :id,              Serial
  property :header,          String
  property :bodysale,        String
  property :showroom_index, Integer
end

DataMapper.finalize

module SalesHelpers 

  def show_sales
    @sales = EyeTest.all
  end

  def create_sale
    @new_sale = EyeTest.create(params[:sales])
  end

end

helpers SalesHelpers

post '/create_sales' do 
  if create_sale
    redirect to ("/sales")
  end
end

get '/sales' do
  show_sales
  slim :sales
end

get '/sales/:id' do
  @sale = Sales.get(params[:id])
end

delete '/sales/:id' do 
  Sales.get(params[:id]).destroy
  redirect to ("/sales")
end


