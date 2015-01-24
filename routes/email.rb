require 'erb'
require 'date'

EMAILPATH = 'email/'
BLUETEMPLATE = 'email/blue.erb'
ORANGETEMPLATE = 'email/orange.erb'
REDTEMPLATE = 'email/red.erb'

#
# NOTE: This is for demonstration purposes only.  We may want
# to allow archived access to emails directly from the application,
# but that is not this route. This route is simply to demonstrate
# rendering of an email template.  Ideally, this would be called
# from the drug script.
#
class Emails < Sinatra::Base
  #
  # Email Routes
  #
 
  # Blue is for low stock (one month notice)
  get '/email/blue/:date' do
    date = Date.parse(params[:date])

    templateString = File.read(BLUETEMPLATE)
    data = { health_center: 'SRQ', 'alerts' => [{name:'Desogen',CPT:'1234',stock:5,rate:2.4,out:date.strftime('%d %b %Y')}]}
    template = ERB.new(templateString).result(binding)

    email = File.new(File.join(EMAILPATH, date.strftime('%Y-%m-%d') + '-blue.html'), 'w')
    email.write(template)
    email.close
  end

  # Orange is for ultra-low stock (one week notice)
  get '/email/red/:date' do
    date = Date.parse(params[:date])

    templateString = File.read(REDTEMPLATE)
    data = { health_center: 'SRQ', 'alerts' => [{name:'Desogen',CPT:'1234',stock:5,rate:2.4,out:date.strftime('%d %b %Y')}]}
    template = ERB.new(templateString).result(binding)

    email = File.new(File.join(EMAILPATH, date.strftime('%Y-%m-%d') + '-red.html'), 'w')
    email.write(template)
    email.close
  end

  # Red is stock out complete (zero or negative stock left)
  get '/email/orange/:date' do
    date = Date.parse(params[:date])

    templateString = File.read(ORANGETEMPLATE)
    data = { health_center: 'SRQ', 'alerts' => [{name:'Desogen',CPT:'1234',stock:5,rate:2.4,out:date.strftime('%d %b %Y')}]}
    template = ERB.new(templateString).result(binding)

    email = File.new(File.join(EMAILPATH, date.strftime('%Y-%m-%d') + '-orange.html'), 'w')
    email.write(template)
    email.close
  end
end
