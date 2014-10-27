# DrugDB Parser
#   A parser to pull in any data from Excel files
#   received from health centers.
#
#   Expects the purchasing file to be of the format:
#   Health Center     Drug Name     CPT Code    Count     Date

require 'rubyXL'

class XLSXParser 
	def initialize(xlsxpath, sheet)
    @book = RubyXL::Parser.parse(xlsxpath)
		@sheet = @book[sheet]
    @data = @sheet.extract_data
	end
	
	def read(skip=3)
    # Defaults to skipping the first three rows
    return @data.drop(skip)
	end

  def page(sheet)
    @sheet = @book[sheet]
    # This could be made into a private method
    @data = @sheet.extract_data
  end
end
