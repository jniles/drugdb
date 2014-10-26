require "data_mapper"
require "bcrypt"

dataPath = "data/init/"
url = "sqlite://#{Dir.pwd}/db/drug.db"
DataMapper.setup :default, url

# pull in parser
require_relative "../parsers/xlsparser"

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
DataMapper.auto_upgrade!

# Initial loading of data
# We are in an uninitialized state.  Let's load all the data

if User.count == 0
  sheet = "user"
  xls = "user.xls"
  puts "[INIT::WARNING] Table `user` is empty.  Initializing data from #{dataPath}#{xls}."
  parser = XLSParser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    User.create(:id => row[0], :name => row[1], :email => row[2], :password => row[3], :created => Time.now)
  end
end

if Manager.count == 0
  sheet = "manager"
  xls = "manager.xls"
  puts "[INIT::WARNING] Table `manager` is empty.  Initializing data from #{dataPath}#{xls}."
  parser = XLSParser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    Manager.create(:id => row[0], :name => row[1], :email=> row[2])
  end
end

if HealthCenter.count == 0
  sheet = "health_center"
  xls = "health_center.xls"
  puts "[INIT::WARNING] Table `health_center` is empty.  Initializing data from #{dataPath}#{xls}."
  parser = XLSParser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    manager = Manager.get(row[2])
    HealthCenter.create(:id => row[0], :name => row[1], :manager => manager)
  end
end

if Drug.count == 0
  sheet = "drug"
  xls = "drug.xls"
  puts "[INIT::WARNING] Table `drug` is empty.  Initializing data from #{dataPath}#{xls}."
  parser = XLSParser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    drug = Drug.create(:name => row[1])
    Cpt.create(:code => row[0], :drug => drug)
  end
end
