require "data_mapper"
require "bcrypt"

#dataPath = "data/init/"
url = "sqlite://#{Dir.pwd}/db/drug.db"
DataMapper.setup :default, url

# TODO: Is there a better way to do this?
require_relative "user"
require_relative "manager"
require_relative "health_center"
require_relative "drug"
require_relative "cpt"
require_relative "correction"
require_relative "count"
require_relative "purchase"
require_relative "sale"

DataMapper.finalize
# WARNING: This is a DEVELOPMENT feature.  Do not run in production,
# it destroys all data every single tim ethe server is run.
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

# Initial loading of data
# We are in an uninitialized state.  Let's load all the data.

# if User.count == 0
#   sheet = "user"
#   xls = "user.xls"
#   puts "[INIT::WARNING] Table `user` is empty.  Initializing data from #{dataPath}#{xls}."
#   parser = XLSParser.new(dataPath + xls, sheet)
#   parser.read().each do |row|
#     User.create(:id => row[0], :name => row[1], :email => row[2], :password => row[3], :created => Time.now)
#   end
#   puts "User.count : #{User.count}"
# end
# 
# if Manager.count == 0
#   sheet = "manager"
#   xls = "manager.xls"
#   puts "[INIT::WARNING] Table `manager` is empty.  Initializing data from #{dataPath}#{xls}."
#   parser = XLSParser.new(dataPath + xls, sheet)
#   parser.read().each do |row|
#     Manager.create(:id => row[0], :name => row[1], :email=> row[2])
#   end
#   puts "Manager.count : #{Manager.count}"
# end
# 
# if HealthCenter.count == 0
#   sheet = "health_center"
#   xls = "health_center.xls"
#   puts "[INIT::WARNING] Table `health_center` is empty.  Initializing data from #{dataPath}#{xls}."
#   parser = XLSParser.new(dataPath + xls, sheet)
#   parser.read().each do |row|
#     manager = Manager.get(row[2])
#     HealthCenter.create(:id => row[0], :name => row[1], :manager => manager)
#   end
#   puts "HealthCenter.count : #{HealthCenter.count}"
# end
# 
# if Drug.count == 0
#   sheet = "drug"
#   xls = "drug.xls"
#   puts "[INIT::WARNING] Table `drugs` is empty.  Initializing data from #{dataPath}#{xls}."
#   parser = XLSParser.new(dataPath + xls, sheet)
#   parser.read().each do |row|
#     drug = Drug.create(:name => row[1])
#     Cpt.create(:code => row[0], :drug => drug)
#   end
#   puts "Drug.count : #{Drug.count}"
# end
