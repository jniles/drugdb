# CSVParser
# Meant to retain a similar API to the XLS parsers
# also included in this folder.
#
# See: http://technicalpickles.com/posts/parsing-csv-with-ruby/

require 'CSV'

# Put a "nil" object if the value is blank.
CSV::Converters[:blank_to_nil] = lambda do |field|
    field && field.empty? ? nil : field
end

class CSVParser
  def initialize(csvpath)
    @document = CSV.new(csvpath, :header=>true, :header_converters=>:symbol, :converters=>:all)
    @rows = @document.to_a.map {|row| row.to_hash }
  end

  def read()
    return @rows
  end

end
