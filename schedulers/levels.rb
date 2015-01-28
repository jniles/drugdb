#!/usr/bin/env ruby

require 'date'
require 'yaml'
require 'ostruct'
require 'erb'
require 'pony'

CONFIG = YAML.load(File.open("config.yaml"))
WARNINGEMAIL = File.join(CONFIG['install_dir'], 'mail/alerts/orange.erb')
DUNGOOFEDEMAIL = File.join(CONFIG['install_dir'], 'mail/alerts/red.erb') #because if you get this email, your stock is negative
#and if your stuck is negative, you dun goofed

require './models/init'

#I copied this from routes\feedback because I don't want to risk encoding issues.
#we should make this part of a "standard DI library", something like aux.rb.
def escape(string)
    if String.method_defined?(:encode)
      string.encode!('UTF-16', 'UTF-8', invalid: :replace, replace: '')
      string.encode!('UTF-8', 'UTF-16')
    else
      ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
      string = ic.iconv(string)
    end
end

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
	puts "Rate: #{rate}, Stock: #{stock}"
  zero = stock / Float(rate)

	#gotta change this code so we actually know the stock, else we miss out on 1/4 of the template

  if stock != 0
    return {level: zero.floor, stock: stock}
  else
    return {level: -Float::INFINITY, stock: 0}
  end
end

def main(levels)
	base_alert_hash = {} #this will separate things out by health center...
  HealthCenter.all.each do |center|
    levels[center.name] = OpenStruct.new
		base_alert_hash[center.name] = {warnings: [], goofs: []} #store them here
		#warnings are when stock is positive, but it'll run out in less than CONFIG[minimum], i.e. WARNINGEMAIL
		#goofs are when you've already got negative stock and you need to get it checked out, i.e. DUNGOOFEDEMAIL
    Cpt.all.each do |cpt| 
			levels[center.name][cpt.code] = level(center,cpt) #ok, first we get the hash...
      levels[center.name][cpt.code][:name] = cpt.drug.name #now add an extra field.
    end
  end

  puts "Health Center\tCPT\tStock Out (days)"
  i = 0
  s = 0
  t = 0
  levels.to_h.each do |k,v|
    v.to_h.each do |n,m|
#      puts "#{k}\t#{n}\t#{m[:level]}" #m is a hash now
			#k is health center, n is CPT, m is {level, drug name, stock}
			
			alert = [m[:name], n, m[:stock], m[:level]] #I changed this to a list because having as .each |k,v| would be silly since hashes are randomly ordered
			#see mail\alerts\orange.erb and red.erb for the reasoning behind this list
			#we do this up here even when we don't need it to avoid code duplication.
      if m[:level] >= 0
				#ok, so we have a drug that runs out in a positive number of days
				#therefore let's check whether we should warn
				if m[:level] < CONFIG['minimum']
					#add to warnings, because it's not quite gone yet. We need drug name though so we need
					base_alert_hash[k.to_s][:warnings].push(alert) #add to the list that we will use to populate Orange
				end
        i += 1 #debug info
      end

      if m[:level] > -Float::INFINITY
        t += 1
				if m[:level] < 0
					#this means your stock is negative, i.e. you've already run out, and you dun goofed
					base_alert_hash[k.to_s][:goofs].push(alert)
				end	
      end

      s += 1
    end
  end
  puts "Positives: #{i}"
  puts "Valid: #{t}"
  puts "Total: #{s}"
	base_alert_hash.each do |health_center,alerts| 
	#so at this point we're ready to fill the templates. Let's load them up.
		alertTemplateString = File.read(WARNINGEMAIL)
		goofTemplateString = File.read(DUNGOOFEDEMAIL)
		data = {
			health_center: health_center,
			alerts: alerts[:warnings]
		}
		alertTemplate = ERB.new(alertTemplateString).result(binding)
		data[:alerts] = alerts[:goofs] #change to goofs
		goofTemplate = ERB.new(goofTemplateString).result(binding)
    message_params= {
	    from: CONFIG['email'][0]['sender'], #YAML syntax quirk - when you make a hash, you get a list of hashes with one element. Why? Because Ruby.
      to: CONFIG['email'][0]['admin'],
      subject: "[Drug Inventory] Drug stocks for health center #{health_center} are running low.",
			html_body: escape(alertTemplate)
    }

    # if we have specified the 'via' methods for delivery,
    # make sure to pass those to Pony
    if CONFIG['email'][0]['via']
      message_params[:via] = CONFIG['email'][0]['via']
      message_params[:via_options] = CONFIG['email'][0]['via_options'][0]
    end

#		Pony.mail(message_params)
		message_params[:subject] = "[Drug Inventory] Database reports that stocks for health center #{health_center} have already run out!"
		message_params[:html_body] = escape(goofTemplate)
#		Pony.mail(message_params)
	end
end

opts = OpenStruct.new
main(opts)
