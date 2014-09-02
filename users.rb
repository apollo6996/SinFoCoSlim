require "data_mapper"
require "dm-core"
require "dm-migrations"
require "bcrypt"

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class User
	include DataMapper::Resource
	include BCrypt

	property :id, 		Serial, :key => true
	property :username, String, :length => 2..10
	property :password, BCryptHash

	def authenticate(attempted_password)
		if self.password == attempted_password
		  true
		else
		  false
		end
	end

end

DataMapper.finalize
DataMapper.auto_upgrade!

module UsersHelpers 

	def show_users
		@users = User.all
	end

	def users_signup
		@user = User.create(params[:user])
	end

end

helpers UsersHelpers