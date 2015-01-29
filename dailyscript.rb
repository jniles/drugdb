#dailyscript.rb
#runs every morning, a parser
#
require 'date'
require './models/init'
#ok folks first let's find out what day today is

today = DateTime.now #this is for querying the database
today_string = today.strftime("%Y%m%d") #this is for calling the script with args

#cool, now we check when we last updated
last_checked = LastDate.first_or_create(:last_update => today).last_update #either finds the first date, or creates a new one
if not last_checked.nil? #make sure it's not null
	#date+1 is date + 1 day, exploit this to our advantage
	while last_checked.to_date != (today+1).to_date #to_date compares days thankfully
		last_checked += 1 #increase by one day
		begin
			Kernel.exec("./parsers/main.rb --date #{last_checked.strftime('%Y%m%d')}")
		rescue
			puts "Failed to get any data for date #{last_checked.strftime('%Y-%m-%d')}"
		end
	end
	last_checked = LastDate.all.update(:last_update => today) #since we only have one record, we just continually update it
else
	puts "We shouldn't be here; if we are, DataMapper is lying about first_or_create."
end
