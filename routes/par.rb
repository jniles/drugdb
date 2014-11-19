require 'ostruct'
require 'date'

class Par < Sinatra::Base

  set :views, Dir.pwd + "/views"

  def getStockInCenter(center, cpt)
    # Get the most recent hand count
    date = Count.max(:date, :conditions => { :cpt => cpt })

    # FIXME
    # We are using this syntax because datamapper is idiotic
    # and .get() requires a four-part key
    count = Count.sum(:count, :conditions => { :cpt => cpt, :date => date })

    # Sometimes, we don't have initialization data for a certain drug.  Therefore,
    # we just return 0 for the stock in the center without need for futher calculation.
    if not (date or date.nil?)
      stock = 0
    else
      # These conditions are used repeatedly, so let's store them in a variable
      conditions = { :cpt => cpt, :health_center => center, :date.gte => date}

      # Get the total sales of the drug since the last hand count
      # We assume that the hand counts are at the beginning of
      # the day, and subtract that day's sales from the hand count
      # if there are sales on the same day as the count.
      # This is out consumption rate
      sales = Sale.sum(:count, :conditions => conditions)

      # Get the total number of purchases since the since the hand count
      # We are including both the start date and today's amount.
      purchases = Purchase.sum(:count, :conditions => conditions) || 0

      # Get the total number of corrections since the hand count
      # NOTE : Corrections can be positive and negative, so this is
      # sufficient (hopefully).
      corrections = Correction.sum(:count, :conditions => conditions) || 0


      # Calculate the amount of the drug in stock
      puts "#{count + corrections + purchases - sales} = #{count} + #{corrections} + #{purchases} - #{sales}"
      stock = count + corrections + purchases - sales
    end

    stock
  end

  def par(center, cpt)
    # Calculate a single drug's current par value for a given health center

    # Number of previous days to include in the rate analysis
    # Should default to 90
    limit = CONFIG['par_limit'] || 180
    start_date = Date.today - limit

    # Calculate the average consumption rate for period of limit to today.
    rate = Sale.sum(:count, :conditions => { :cpt => cpt, :date.gte => start_date }) / limit

    # get the current stock level of the given drug
    stock = getStockInCenter(center, cpt)

    # find the zero by solving the equation
    # lvl = rate*(days_after_today) + stock_lvl
    # for 0.
    rate = rate == 0 ? 1 : rate
    zero = stock / Float(rate)
    zero.floor
  end

  get '/par/:center/:drug' do
    # :center is a health center id
    # :drug is a drug CPT code or all
    #env['warden'].authenticate!

    # get the health center
    center = HealthCenter.get(params[:center])
    cpt = Cpt.get(params[:drug])

    lvl = par(center, cpt)

    "The par level is : #{lvl} days"
  end
end
