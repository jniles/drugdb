require 'erb'
require 'date'

EMAILPATH = "email/"
BLUETEMPLATE = "email/blue.erb"
ORANGETEMPLATE = "email/orange.erb"
REDTEMPLATE = "email/red.erb"

class Emails < Sinatra::Base

  #
  # Email Routes
  #
  
  get '/email/:date' do
    date = Date.parse(params[:date])
    puts "Date is: #{date}"
    template = File.read(BLUETEMPLATE)
    health_center = "SRQ"
    alerts = [{"name"=>"Desogen","CPT"=>"1234","stock"=>5,"rate"=>2.4,"out"=>date.strftime('%a %d %b %Y')}]
    renderer = ERB.new(template)
    result = renderer.result(binding)
    email = File.new(File.join(EMAILPATH, date.strftime('%Y-%m-%d') + '.html'), "w")
    email.write(result)
    email.close
  end

end
