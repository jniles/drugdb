#!/usr/bin/env ruby

# dependencies
require 'sinatra'
require 'sinatra/content_for'
require 'active_record'
require 'chartkick'
require 'warden'
require 'date'
require 'yaml'

# init models
require './models/init'

# routes
require './routes/auth'
require './routes/home'
require './routes/users'
require './routes/corrections'
require './routes/feedback'
require './routes/display' #for charts

module SST
  class App < Sinatra::Base
    enable :sessions, :logging

    set :environment, :production
    set :views, Dir.pwd + '/views'

    # middleware
    use Auth
    use Home
    use Users
    use Feedback
    use Corrections
    use DrugDisplay

    get '/' do
      env['warden'].authenticate!
      redirect '/home'
    end

    get '/login' do
      erb :login
    end

    # TODO
    # Let's decide on a better way of doing this,
    # shall we?  It is potentially quite confusing.
    not_found do
      redirect '/home'
    end
  end
end
