require "data_mapper"
require "bcrypt"

dataPath = "../data/init/"
url = "sqlite://#{Dir.pwd}/db/drug.db"
DataMapper.setup :default, url

# pull in parser
require_relative "../parser"

# TODO: Is there a better way to do this?
require_relative "user"
require_relative "drug"
require_relative "manager"
require_relative "correction"
require_relative "count"
require_relative "purchase"
require_relative "sale"
require_relative "health_center"

DataMapper.finalize
DataMapper.auto_upgrade!

if User.count == 0
  # We are in an uninitialized state.  Let's load all the data
  puts "Loading data from #{dataPath}"
  columns = ["id", "name", "password", "token", "created", "updated", "active"]
  parser = Parser.new(dataPath + 'user.xlsx', sheet, columns)
  parser.read()
  #.each do |row|
  #  User.create(:id => row.id, :name => row.name);
  #end
end
