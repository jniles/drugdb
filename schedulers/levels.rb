#!/usr/bin/env ruby

require 'date'
require 'yaml'
require 'ostruct'

CONFIG = YAML.load(File.open("config.yaml"))

require './models/init'

def getStockInCenter(center, cpt)
  # Get the most recent hand count
  date = Count.max(:date, :conditions => { :cpt => cpt })

  # Sometimes, we don't have initialization data for a certain drug.  Therefore,
  # we just return 0 for the stock in the center without need for futher calculation.
  if not date or date.nil?
    stock = 0
  else
    # These conditions are used repeatedly, so let's store them in a variable
    conditions = { :cpt => cpt, :health_center => center, :date.gte => date}

    # FIXME
    # We are using this syntax because datamapper is idiotic
    # and .get() requires a four-part key
    count = Count.sum(:count, :conditions => conditions) || 0


    # Get the total sales of the drug since the last hand count
    # We assume that the hand counts are at the beginning of
    # the day, and subtract that day's sales from the hand count
    # if there are sales on the same day as the count.
    # This is out consumption rate
    sales = Sale.sum(:count, :conditions => conditions) || 0

    # Get the total number of purchases since the since the hand count
    # We are including both the start date and today's amount.
    purchases = Purchase.sum(:count, :conditions => conditions) || 0

    # Get the total number of corrections since the hand count
    # NOTE : Corrections can be positive and negative, so this is
    # sufficient (hopefully).
    corrections = Correction.sum(:count, :conditions => conditions) || 0

    # Calculate the amount of the drug in stock
    stock = count + corrections + purchases - sales
  end

  stock
end

def level(center, cpt)
  # Calculate a single drug's current par value for a given health center

  # number of previous days to include in the rate analysis
  # should default to 90 (three months)
  limit = CONFIG['hindsight'] || 90
  start_date = Date.today - limit
  
  # calculate the average consumption rate for period of limit to today.
  sum = Sale.sum(:count, :conditions => { :cpt => cpt, :date.gte => start_date }) || 0;
  rate = sum / limit

  # get the current stock level of the given drug
  stock = getStockInCenter(center, cpt)

  # find the zero by solving the equation
  # lvl = rate*(days_after_today) + stock_lvl
  # for 0.
  # ensure that rate is non-zero
  rate = rate == 0 ? 1 : rate
  zero = stock / Float(rate)

  if stock != 0
    zero.floor
  else
    -Float::INFINITY
  end
end

def main(levels)

  HealthCenter.all.each do |center|
    levels[center.name] = OpenStruct.new
    Cpt.all.each do |cpt| 
      levels[center.name][cpt.code] = level(center, cpt)
    end
  end

  puts "Health Center\tCPT\tStock Out (days)"
  i = 0
  s = 0
  t = 0
  levels.to_h.each do |k,v|
    v.to_h.each do |n,m|
      puts "#{k}\t#{n}\t#{m}" 
      if m >= 0
        i += 1
      end

      if m > -Float::INFINITY
        t += 1
      end

      s += 1
    end
  end
  puts "Positives: #{i}"
  puts "Valid: #{t}"
  puts "Total: #{s}"
end

opts = OpenStruct.new
main(opts)
