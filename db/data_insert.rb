require 'sqlite3'
require 'spreadsheet'

class Updater
	def initialize(filePath)
		@db = SQLite3::Database.new(filePath)
	end
	
	def monthly_update(center, spreadsheet)
		sheet1 = spreadsheet.worksheet 0
		sheet1.each do |row|
			#if the drug is not in the drug table put it there
			if @db.execute("select Dname from DRUG where Dname=:adrug", "adrug" => row[0] )[0] == nil
				@db.execute( "insert into DRUG values(:adrug)", "adrug" => row[0] )
			end
			#if the drug is not in drug per loc for specified center then add it
			if @db.execute("select Dname from DRUG_PER_LOC where Dname=:adrug and ctr_loc = :center", "adrug" => row[0], "center" => center )[0] == nil
				@db.execute( "insert into DRUG_PER_LOC values(:center,:adrug, :par_lvl, :flag, :count)",
								"center" => center, 
								"adrug" => row[0],
								"par_lvl" => "0",
								"flag" => "None",
								"count" => row[1])
			else #if it is then update it
				@db.execute( "update DRUG_PER_LOC SET Count=:count where Dname=:adrug and Center=:center", 
								"count" => row[1], 
								"adrug" => row[0], 
								"center" => center)
			end
		end
	end
end

book = Spreadsheet.open 'Health Center Inventory.Fiscal 2014.fixed.xls'
test = Updater.new("drug.db")
test.monthly_update("Sarasota HC", book)

