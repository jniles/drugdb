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
require './routes/account'
require './routes/display' #for charts

module SST
  class App < Sinatra::Base
    enable :sessions

    # middleware
    use Auth
    use Emails
    use Accounts
    #use Graphs # TODO : impliment this

    get '/' do
      env['warden'].authenticate!
      "Hello world"
    end

    get '/jonathan' do
      env['warden'].authenticate!
      "NEW ROUTE"
    end

  end
end
