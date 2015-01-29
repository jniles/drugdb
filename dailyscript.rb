#dailyscript.rb
#runs every morning, a parser
#
require 'date'
require 'data_mapper'
require 'dm-sqlite-adapter'
require './models/last_date'
#ok folks first let's find out what day today is

today = DateTime.now #this is for querying the database
today_string = today.strftime("%Y%m%d") #this is for calling the script with args

#cool, now we check when we last updated
last_checked = LastDate.first()
puts last_checked
puts last_checked+1
