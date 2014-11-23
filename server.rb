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
require './routes/email'
require './routes/account'
require './routes/corrections'
require './routes/display' #for charts

module SST
  class App < Sinatra::Base
    enable :sessions

    # middleware
    use Auth
    use Home
    use Emails
    use Accounts
    use Corrections
    use DrugDisplay
    #use Display

    get '/' do
      env['warden'].authenticate!
      redirect "/home"
    end
  end
end
