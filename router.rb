require './view_helpers'


get '/*/*/line_chart' do |location, drug_name|
  location.capitalize!
  drug_name.capitalize!
  data_points = DataPoint.where(
    ctr_loc: location,
    dname: drug_name
  ).all
  data = data_points.map {|datum| [datum['Time_stamp'], datum['Count'].to_i] }
  erb :line_graph, locals: {data: data}, layout: false
end

get '/settings' do
  erb :settings
end

get '/*' do |location|
  #TODO: raise unless location exists
  @location = location
  @drug_data_points = DrugsPerLoc.where(Ctr_loc: @location).all
  @alerts = DrugsPerLoc.alerts.all
  @title = 'Planned Parenthood Drug Inventory'
  erb :index
end