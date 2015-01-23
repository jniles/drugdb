#!/usr/bin/env ruby

# main.rb
#
# This is the main command line runner for
# all parsers inserting data into the drug.db.

# TODO
#  The following features are sorely missing, to add
#  dependency management and crash managment to the
#  application:
#   --log=FILE        Output verbose log to a file.

require 'optparse'
require 'optparse/date'
require 'ostruct'
require 'yaml'

# parsers
require './parsers/controller'
require './parsers/inventory'
require './parsers/sale'
require './parsers/purchase'


# globals
VERSION = "0.1.0"
CONFIG = YAML.load(File.open("config.yaml"))

# models
require './models/init'

# OptParse
#   Allows command line control of the parsing scripts.
class OptParse

  def self.parse(args)
    options = OpenStruct.new

    # Assign config.yaml variables to struct
    #
    options.data_path = CONFIG['data_path']
    options.schema = CONFIG['schema']
    options.db = CONFIG['db']
    options.sqlite = CONFIG['sqlite']

    # default struct values
    options.verbose = false
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

      opts.on("--install", "Build the database before running parsing scripts") do
        options.install = true
      end

      opts.on("--rebuild", "Rebuilds the data in the drug inventory database.") do
        options.rebuild = true
      end

      opts.on("--rebuild-drugs", "Rebuilds just the cpt code table") do 
        options.rebuild_drugs = true;
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

# Let's be semantic like in C or Python!
def main(options)
  puts "Running drug inventory parser."

  if options.install
    Controller.install(options)
  end

  if options.rebuild
    Controller.rebuild(options)
  end

  if options.rebuild_drugs
    Controller.rebuild_drugs(options)
  end

  # escape if no date specified
  if not options.date
    return
  end

  # Parse Inventory Counts
  inventory = InventoryCountsParser.new(options)
  inventory.parse()

  # Parse Sales
  sales = SaleParser.new(options)
  sales.parse()

  # Parse Purchases
  purchases = PurchaseParser.new(options)
  purchases.parse()

  puts "Closing drug inventory parser."
end

# This is the equivalent of if __name__ == '__main__' in python
if __FILE__ == $0

  # Parse the call arguments
  options = OptParse.parse(ARGV)

  # Run this script
  main options
end
