require 'erb'
require 'date'

BLUETEMPLATE = 'email/blue.erb'
ORANGETEMPLATE = 'email/orange.erb'
REDTEMPLATE = 'email/red.erb'

class Emails < Sinatra::Base

  #
  # Email Routes
  #
  
  get '/email/:date' do
    date = Date.parse(params[:date])
    puts "Date is: #{date}"
  end

end
