# DrugDB Parser
#   A parser to pull in any data from Excel files
#   received from health centers.
#
#   Expects the purchasing file to be of the format:
#   Health Center     Drug Name     CPT Code    Count     Date
#
#   Writes the data into an SQLite database contained in the file 'drug.db'
#
#
#   For CSV parsing, see: http://technicalpickles.com/posts/parsing-csv-with-ruby/

require 'spreadsheet'

class XLSParser 
	def initialize(xlspath, sheet)
    @book = Spreadsheet.open xlspath
		@sheet = @book.worksheet sheet
	end
	
	def read()
    rows = []
		@sheet.each 3 do |row| # omit header rows, start at fourth row
      if row.all? { | entry | defined? (entry).nil? } # validation
        rows << row
      else 
        puts "[PARSER::WARNING] Omitting row: #{row}" 
      end
		end
    return rows
	end

  def page(sheet)
    @sheet = @book.worksheet sheet
  end
end

