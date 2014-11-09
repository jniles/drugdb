require 'ostruct'

class Corrections < Sinatra::Base

  #
  # Correction Routes
  # 
  
  get '/corrections/:center' do
    data = Corrections.all(:health_center => params[:center])
    erb :'corrections/table'
  end
  
  get '/corrections/new' do
    data = OpenStruct.new
    data.error = {}
    data.drugs = Drug.all
    data.centers = HealthCenters.all
    erb :'corrections/form'
  end

  get '/corrections/success' do
    data = Count.all
    erb :'corrections/success'
  end

  post '/corrections/submit' do
    data = OpenStruct.new
    p params
    params[:erb]
  end

end
