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
require './models/health_center'

class InventoryCountsParser

  MODULE = "PARSER - INVENTORY"

  def initialize(file, options)
    @options = options
    @workbook = RubyXL::Parser.parse(file)
    stdout("Initialized new workbook from: '#{file}'")
  end

  def parse()
    if @options.all_centers
      stdout("Parsing all centers")
      HealthCenter.all.each do |health_center|
        parseSheet(health_center)
      end
    elsif @options.centers
      @options.centers.each do |center|
        health_center = HealthCenter.get(center)
        parseSheet(health_center)
      end
    else
      raise "No worksheets specified to parse!"
    end
  end

  def parseSheet(center)
    stdout("Parsing center #{center.name}")
    data = @workbook[center.name].extract_data

    counts = 0

    # Ignore the first three lines of header content
    content = data.drop(3)

    # For each line in the excel file, we verify
    # that it is not empty, gather the drug_code
    # and parse the date.  We then write a new
    # Count record.
    content.each do |row|
      if not row.empty?
        drug_code = Cpt.get(row[2])
        if not drug_code.nil?
          date = Date.parse(row[4].to_s)
          Count.create({:cpt => drug_code, :count => row[3], :date => date, :health_center => center})
          counts += 1
        else
          stdout("Warning: Drug CPT code is nil for row #{content.index(row)}")
        end
      end
    end

    stdout("Finished parsing health center #{center.name}")
    stdout("Wrote #{counts} lines to the database.")
  end

  def stdout(data)
    if @options.verbose
      puts "[#{MODULE}][#{Time.new()}] #{data}."
    end
  end
end
