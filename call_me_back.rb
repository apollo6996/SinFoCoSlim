require "data_mapper"
require "dm-core"
require "dm-migrations"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class CallMeBack
	include DataMapper::Resource
	property :id, 		Serial
	property :name, 	String
	property :phone, 	Integer
end

DataMapper.finalize

module CallMeBackHelpers 

	def show_callbacks_requests
		@callbacks = CallMeBack.all
	end

	def signup_callmeback
		@callback = CallMeBack.create(params[:callback])
	end

end

helpers CallMeBackHelpers

post '/call_me_back' do 
	if signup_callmeback
		redirect to ("/")
	end
end

get '/callbacks_requests' do
  show_callbacks_requests
  slim :show_callbacks_requests
end

get '/callbacks_requests/:id' do
  @callbacks_request = CallMeBack.get(params[:id])
end

delete '/callbacks_requests/:id' do 
  CallMeBack.get(params[:id]).destroy
  redirect to ("/tickets")
end


