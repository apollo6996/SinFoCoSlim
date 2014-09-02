require "data_mapper"
require "dm-core"
require "dm-migrations"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class EyeTest
	include DataMapper::Resource
	property :id, 			  Serial
	property :name, 		  String
	property :phone, 		  Integer
	property :showroom_index, Integer
end

DataMapper.finalize

module EyeTestHelpers 

	def show_testers
		@eye_testers = EyeTest.all
	end

	def signup
		@eye_test = EyeTest.create(params[:eye_test])
	end

end

helpers EyeTestHelpers

post '/eye_test' do 
	if signup
		redirect to ("/")
	end
end

get '/eye_testers' do
  show_testers
  slim :show_testers
end

get '/eye_testers/:id' do
  @eyetester = EyeTest.get(params[:id])
end

delete '/eye_testers/:id' do 
  EyeTest.get(params[:id]).destroy
  redirect to ("/tickets")
end


