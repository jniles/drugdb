#!/usr/bin/env ruby -I ../lib -I lib
require 'sinatra'
require 'sinatra/content_for'
require 'active_record'
require 'chartkick'
require 'warden'

# init models
require_relative 'models/init.rb'

# routes 
require_relative 'routes/auth.rb'
require_relative 'routes/display.rb' #for charts

module SST
  class App < Sinatra::Base
    enable :sessions

    # middleware
    use Auth

    get '/' do
      env['warden'].authenticate!
      "Hello world"
    end

    get '/protected' do
      env['warden'].authenticate!
      "Hey, you are logged in!"
    end
  end
end
