class Corrections < Sinatra::Base

  #
  # Correction Routes
  # 
  
  get '/corrections/:center' do
    data = Corrections.all(:health_center => params['center'])
    erb :'corrections/table'
  end
  
  get '/corrections/new' do
    erb :'corrections/form'
  end

  get '/corrections/success' do
    data = Count.all
    erb :'corrections/success'
  end

  post '/corrections' do
  end

end
