#!/usr/bin/env ruby

# main.rb
# 
# This is the main command line runner for
# all parsers inserting data into the drug.db.

require 'rubyXL'
require 'optparse'
require 'optparse/time'
require 'ostruct'

require './parsers/inventory'

VERSION = 0.1

# OptParse
#   Allows command line control of the parsing scripts.
class OptParse

  def self.parse(args)
    options = OpenStruct.new
    options.verbose = false
    options.centers = []

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: main.rb [options] [filename]"

      opts.on('-v', '--[no-]verbose', "Run verbosely.") do |v|
        options.verbose = v
      end

      opts.on("-c", "--health-center [CENTER]", "Import only the given health center.") do |c|
        options.centers << c
      end

      opts.on("-a", "--all-centers", "Import all health centers in the file.") do |v|
        options.all_centers = v 
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
parser = InventoryCountsParser.new(ARGV[0], options)
parser.parse()

