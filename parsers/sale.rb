# SaleParser
#
# Pulls data out of Sales.xlsx files and
# inserts them into the Sale database table

require 'rubyXL'

require './models/init'
require './models/health_center'
require './models/cpt'
require './models/sale'

# TODO : Eventually use a class-inheritence style
# infrastructure to combine these parsers into a
# single parent class and many parser children.
class SaleParser

  MODULE = 'PARSER - SALES'
  FILENAME = 'Sales.xlsx'

  def _ensure(file)
    File.file?(file)
  end

  def initialize(options)
    @options = options

    # parse the date into a folder name
    folder = options.date.strftime('%Y%m%d')

    # Ensure the file's existence
    path = File.join(@options.data_path, folder, FILENAME)
    if !_ensure(path)
      fail "Could not find locate #{path}.  Does it exist?"
    end

    # Open the workbook
    @workbook = RubyXL::Parser.parse(path)
    stdout("Initialized new workbook from: '#{path}'")
  end

  def parse
    if @options.all_centers
      stdout('Parsing all health centers in file.')
      HealthCenter.all.each do |health_center|
        parse_sheet(health_center)
      end
    elsif @options.centers
      @options.centers.each do |center|
        health_center = HealthCenter.get(center)
        if health_center.nil?
          stdout("Warning: Could not find health center #{center}")
        else
          parse_sheet(health_center)
        end
      end
    else
      fail 'No worksheets specified to parse!'
    end
  end

  def parse_sheet(center)
    stdout("Parsing : #{ center.name }")
    data = @workbook[center.name].extract_data

    # TODO : DataMapper must have some way of getting
    # the number of inserted rows, right?
    initial_count = Sale.count

    # Ignore the first three lines of header content
    content = data.drop(3)

    # For each line in the excel file, we verify
    # that it is not empty, gather the drug_code
    # and parse the date.  We then write a new
    # Count record.
    content.each do |row|

      # FIXME : This is ultra safe.  Why?  Because XLSX parsing is
      # difficult and the RubyXL gem often includes random arrays of
      # nil values.  So, we check whether the array exist, is empty,
      # or only contains nil values.
      if !row.nil? || row.empty? || row.all? {|e| e.nil? }
        drug_code = Cpt.get(row[2])
        unless drug_code.nil?
          date = Date.parse(row[4].to_s)
          begin
            Sale.create(cpt: drug_code, count: row[3], date: date, health_center: center)
          rescue
          end
        else
          stdout("Warning: Drug CPT code is nil for row #{row}")
        end
      end
    end

    final_count = Sale.count
    added = final_count - initial_count

    stdout("Finished parsing health center : #{ center.name }")
    stdout("Wrote #{added} lines to the database.")
  end

  def stdout(data)
    return unless @options.verbose
    puts "[#{ MODULE }][#{ Time.new }] #{ data }."
  end
end
