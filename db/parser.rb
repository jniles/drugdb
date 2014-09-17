# DrugDB Parser
#   A proof of concept parser to pull in purchasing data from an Excel
#   file received from health centers.
#
#   Expects the purchasing file to be of the format:
#   Health Center     Drug Name     CPT Code    Count     Date
#
#   Writes the data into an SQLite database contained in the file 'drug.db'

require 'sqlite3'
require 'spreadsheet'

class Parser 
	def initialize(dbpath)
		@db = SQLite3::Database.new(dbpath)
	end

  def getCenterByName(name)
    centers = @db.execute('SELECT id FROM health_center WHERE name = ?', name)
    return centers[0]
  end

  def getDrugCode(name)
    drugs = @db.execute('SELECT cpt_code FROM drug WHERE name = ?')
    return drugs[0]
  end
	
	def extract(center, spreadsheet)
		sheet = spreadsheet.worksheet 0
		sheet.each 1 do |row| # omit header row, start at second row
      if row.all? { | entry | defined? (entry).nil? } # validation
        @db.execute('INSERT INTO purchase VALUES (NULL, ?, ?, ?, ?, ?);', row)
      else 
        puts "[WARNING] Could not process row." 
      end
		end
	end

end

book = Spreadsheet.open './purchase.xls'
parser = Parser.new("./drug.db")
parser.extract("Sarasota HC", book)

