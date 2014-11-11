# NOTE
# This seems a bit much for a single route, but it
# is nice and clean.  Maybe think about condensing
# some classes later once the application has formally
# taken shape.

require 'ostruct'
require 'time' 

class Home < Sinatra::Base
  #
  # Home Routes
  #

	set :views, Dir.pwd + "/views"
  startup = Time.now  # this is set at app startup

  # Calculate the uptime, given a startime
  # Expect start to be a Time object
  def uptime(start)
    diff = Time.at(Time.now - start)
    (diff - diff.gmt_offset).strftime("%H:%M:%S")
  end

  get '/home' do
		env['warden'].authenticate!
    data = OpenStruct.new
    data.user = env['warden'].user
    data.startup = startup
    data.uptime = uptime(startup)
    erb :'home/home', :locals => { :data => data }
  end
end
