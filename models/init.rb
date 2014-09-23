require "data_mapper"
require "bcrypt"

url = "sqlite://#{Dir.pwd}/db/drug.db"
DataMapper.setup :default, url

require_relative "user"

DataMapper.finalize
DataMapper.auto_upgrade!

if User.count == 0
  @user = User.create(name: 'jniles')
  @password = 'secret'
  @user.save
end
