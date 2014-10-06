require "data_mapper"
require "bcrypt"

dataPath = "data/init/"
url = "sqlite://#{Dir.pwd}/db/drug.db"
DataMapper.setup :default, url

# pull in parser
require_relative "../parser"

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
  puts "[INIT::USER] Loading data from #{dataPath}"
  sheet = "user"
  xls = "user.xls"
  parser = Parser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    User.create(:id => row[0], :name => row[1], :email => row[2], :password => row[3], :created => Time.now)
  end
end

if Manager.count == 0
  puts "[INIT::MANAGER] Loading data from #{dataPath}"
  sheet = "manager"
  xls = "manager.xls"
  parser = Parser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    puts "[PARSER::READ] Read: #{row}"
    Manager.create(:id => row[0], :name => row[1], :email=> row[2])
  end
end

if HealthCenter.count == 0
  puts "[INIT::HEALTHCENTER] Loading data from #{dataPath}"
  sheet = "health_center"
  xls = "health_center.xls"
  parser = Parser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    puts "[PARSER::READ] Read: #{row}"
    manager = Manager.get(row[3])
    HealthCenter.create(:id => row[0], :name => row[1], :manager => manager)
  end
end

if Drug.count == 0
  puts "[INIT::DRUG] Loading data from #{dataPath}"
  sheet = "drug"
  xls = "drug.xls"
  parser = Parser.new(dataPath + xls, sheet)
  parser.read().each do |row|
    puts "[PARSER::READ] Read: #{row}"
    drug = Drug.create(:name => row[1])
    Cpt.create(:code => row[2], :drug => drug)
  end
end
