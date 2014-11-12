require 'ostruct'
require 'date'

class Corrections < Sinatra::Base
  # Correction Routes
  #   These routes power the corrections interface component
  #   of Drug Inventory.  They expose URLs to:
  #     - display all the currections in the database
  #     - display corrections for a given center
  #     - create a new correction.
  #

  set :views, Dir.pwd + "/views"

  get '/corrections/center/?:center?' do
    env['warden'].authenticate!
    data = OpenStruct.new
    data.center = HealthCenter.get(params[:center])

    # Load the corrections for a given health center, if specified
    # default to loading all corrections recoreded.
    if params[:center]
      data.corrections = Correction.all(:health_center => data.center, :order => [:date.desc])
    else
      data.corrections = Correction.all(:order => [:date.desc])
    end

    p data
    erb :'corrections/table', :locals => { :data => data }
  end

  get '/corrections/new' do
    env['warden'].authenticate!
    data = OpenStruct.new
    data.errors = {}

    # Sort by alphabetical names for easy searching
    data.drugs = Cpt.all.sort_by { |cpt| cpt[:code] }
    data.centers = HealthCenter.all.sort_by { |center| center[:name] }

    erb :'corrections/form', :locals => { :data => data }
  end

  get '/corrections/success' do
    env['warden'].authenticate!
    data = OpenStruct.new
    data.corrections = Correction.all
    data.corrections.sort_by { |correction| correction[:date] }
    erb :'corrections/success', :locals => { :data => data }
  end

  post '/corrections/submit' do
    # Note: There are two ways of sharing POST data between
    # sinatra routes. I am opting for using session, it seems
    # cleaner.
    # href: http://www.sinatrarb.com/intro.html#Browser%20Redirect

    env['warden'].authenticate!
    data = OpenStruct.new
    errors = {}

    # Was I given a valid health center?
    center = HealthCenter.get(params[:center])
    errors[:center] = center.nil?

    # Was I given a valid drug?
    cpt = Cpt.get(params[:cpt])
    errors[:cpt] = cpt.nil?

    # TODO Try-catch-except
    date = Date.parse(params[:date])

    correction = Correction.create({ :cpt => cpt, :date => date, :count => params[:count], :health_center => center })

    if correction.saved?
      redirect '/corrections/success'
    else
      # Fill in extra errors
      errors[:date] = false
      errors[:count] = false

      # Sort by alphabetical names for easy searching
      data.drugs = Cpt.all.sort_by { |c| c[:code] }
      data.centers = HealthCenter.all.sort_by { |c| c[:name] }

      # Expose errors to the view
      data.errors = errors
      erb :'corrections/form', :locals => { :data => data }
    end
  end
end
