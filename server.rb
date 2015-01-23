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
require './routes/display' #for charts

module SST
  class App < Sinatra::Base
    enable :sessions, :logging

    set :environment, :production
    set :views, Dir.pwd + "/views"

    # middleware
    use Auth
    use Home
    use Users 
    use Corrections
    use DrugDisplay

    get '/' do
      env['warden'].authenticate!
      redirect "/home"
    end

    get '/login' do 
      erb :login
    end
  end
end
