# InventoryCountParser
#
# Pulls data out of InventoryCounts .xlsx files and
# inserts them into the Inventory Count database table

require 'ostruct'
require 'date'
require 'rubyXL'

require './models/init'
require './models/count'
require './models/cpt'

class InventoryCountsParser

  MODULE = "PARSER - INVENTORY"

  def initialize(file, options)
    @options = options
    @workbook = RubyXL::Parser.parse(file)
    stdout("Initialized new workbook from file: '#{file}'")
  end

  def parse()
    if @options.all_sheets
      stdout("Parsing all sheets")
      @workbook.worksheets.each { |sheet| parseSheet(sheet) }
      extractAllSheets
    elsif @options.sheets
      @options.sheets.each { |sheet| parseSheet(sheet) }
    else
      raise "No worksheets specified to parse!"
    end
  end

  def parseSheet(sheet)
    stdout("Parsing sheet #{sheet}")
    sheet = @workbook.worksheets[sheet]
    data = sheet.extract_data

    counts = 0

    # The health center is given in the sheet
    # name.  We can get this first thing
    health_center = Center.get(sheet)

    # Ignore the first three lines of header content
    content = data.drop(3)

    # For each line in the excel file, we verify
    # that it is not empty, gather the drug_code
    # and parse the date.  We then write a new
    # Count record.
    content.each do |row|
      if not row.empty?
        drug_code = Cpt.get(row[2])
        if not cpt.nil?
          stdout("Warning: Drug CPT code is nil for row #{content.index(row)}")
          date = Date.parse(row[4].to_s)
          Count.create({:cpt => drug_code, :count => row[3], :date => date, :health_center => health_center})
          counts += 1
        end
      end
    end

    stdout("Finished parsing sheet #{sheet}")
    stdout("Wrote #{counts} lines to the database.")
  end

  def stdout(data)
    if @options.verbose
      puts "[#{MODULE}][#{Time.new()}] #{data}."
    end
  end
end
