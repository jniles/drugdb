#!/usr/bin/env ruby

# dependencies
require 'sinatra'
require 'sinatra/content_for'
require 'active_record'
require 'chartkick'
require 'warden'

# init models
require './models/init'

# routes 
require './routes/auth'
require './routes/email'
require './routes/display' #for charts

module SST
  class App < Sinatra::Base
    enable :sessions

    # middleware
    use Auth
    use Emails
    #use Graphs # TODO : impliment this

    get '/' do
      env['warden'].authenticate!
      "Hello world"
    end

  end
end
