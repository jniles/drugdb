# This parser is abandoned due to issues reading in formulas.
#


require 'spreadsheet'

class XLSParser 
	def initialize(xlspath, sheet)
    @book = Spreadsheet.open xlspath
		@sheet = @book.worksheet sheet
	end
	
	def read()
    rows = []
    breaks = 0
    maxBreaks = 4
		@sheet.each 3 do |row| # omit header rows, start at fourth row
      if row.any?
        rows << row
      else 
        puts "[PARSER::WARNING] Omitting empty row." 
        breaks += 1
      end

      if maxBreaks < breaks # HACK HACK HACK
        break
      end
		end
    return rows
	end

  def page(sheet)
    @sheet = @book.worksheet sheet
  end
end

