#!/usr/bin/env ruby

# dependencies
require 'sinatra'
require 'sinatra/content_for'
require 'active_record'
require 'chartkick'
require 'warden'

# init models
require './models/init.rb'

# routes 
require './routes/auth.rb'
require './routes/email.rb'
require './routes/display.rb' #for charts

module SST
  class App < Sinatra::Base
    enable :sessions

    # middleware
    use Auth
    use Emails

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
