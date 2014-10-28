#!/usr/bin/env ruby

# main.rb
# 
# This is the main command line runner for
# all parsers inserting data into the drug.db.

require 'rubyXL'
require 'optparse'
require 'optparse/time'
require 'ostruct'

require_relative './inventory.rb'

VERSION = 0.1

# OptParse
#   Allows command line control of the parsing scripts.
class OptParse

  def self.parse(args)
    options = OpenStruct.new
    options.verbose = false
    options.sheets = []

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: main.rb [options] [filename]"

      opts.on('-v', '--[no-]verbose', "Run verbosely") do |v|
        options.verbose = v
      end

      opts.on("-s", "--sheet [SHEET]", "Process only the given sheet") do |s|
        options.sheets << s
      end

      opts.on("-a", "--all-sheets", "Process all sheets in the file") do |v|
        options.all_sheets = v 
      end

      opts.on_tail("--version", "Show version") do
        puts VERSION
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end
end

options = OptParse.parse(ARGV)

p options
