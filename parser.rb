# DrugDB Parser
#   A proof of concept parser to pull in purchasing data from an Excel
#   file received from health centers.
#
#   Expects the purchasing file to be of the format:
#   Health Center     Drug Name     CPT Code    Count     Date
#
#   Writes the data into an SQLite database contained in the file 'drug.db'
#
#
#   For CSV parsing, see: http://technicalpickles.com/posts/parsing-csv-with-ruby/

require 'spreadsheet'

class Parser 
	def initialize(xls, sheet)
    book = Spreadsheet.open xls
		@sheet = book.worksheet sheet
	end
	
	def read()
    rows = []
		@sheet.each 1 do |row| # omit header row, start at second row
      if row.all? { | entry | defined? (entry).nil? } # validation
        rows << row
      else 
        puts "[PARSER::WARNING] Omitting row: #{row}" 
      end
		end
    return rows
	end
end

