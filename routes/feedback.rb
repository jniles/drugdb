
# This module is responsible for allowing users to submit feedback
class Feedback < Sinatra::Base
  #
  # Feedback Routes
  #

  set :views, Dir.pwd + '/views'

  get '/feedback' do
    env['warden'].authenticate!

    erb :'feedback/form'
  end

  post '/feedback/submit' do
    env['warden'].authenticate!

    puts params

    erb :'feedback/thanks'
  end
end
