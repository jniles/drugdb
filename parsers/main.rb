#!/usr/bin/env ruby

# main.rb
#
# This is the main command line runner for
# all parsers inserting data into the drug.db.

require 'optparse'
require 'optparse/date'
require 'ostruct'
require 'yaml'

# parsers
require './parsers/inventory'
require './parsers/sale'
require './parsers/purchase'

# globals
VERSION = 0.1
CONFIG = YAML.load(File.open("config.yaml"))

# OptParse
#   Allows command line control of the parsing scripts.
class OptParse

  def self.parse(args)
    options = OpenStruct.new
    options.verbose = false
    options.data_path = CONFIG['abs_data_path']
    options.centers = []
    options.all_centers = true

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: main.rb [options] [filename]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on('-v', '--[no-]verbose', "Run verbosely.") do |v|
        options.verbose = v
      end

      opts.on("--date [DATE]", Date, "Import counts, purchase, and sales data for a given date")  do |date|
        options.date = date
      end

      opts.on("--health-center x,y,z", Array, "Import only the given health center(s)") do |centers|
        options.all_centers = false
        options.centers << centers
      end

      opts.on("-o", "--out [FILE]", "Log output to file") do |f|
        puts "Not yet implimented."
        exit
      end

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail("-h", "--help", "Show this message.") do
        puts opts
        exit
      end

      opts.on_tail("--version", "Show version.") do
        puts VERSION
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end
end

options = OptParse.parse(ARGV)

# Parse Inventory Counts
iparser = InventoryCountsParser.new(options)
iparser.parse()

# Parse Sales
sparser = SaleParser.new(options)
sparser.parse()

# Parse Purchases
pparser = PurchaseParser.new(options)
pparser.parse()
