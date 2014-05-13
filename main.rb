#!/usr/bin/env ruby -I ../lib -I lib
require 'sinatra'
require 'active_record'
require 'sinatra/content_for'
require 'chartkick'

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'drugdb',
  :username => 'root'
)

# Loading our models
Dir[File.dirname(__FILE__) + '/models/*.rb'].each do |file|
  puts "Requiring #{file}"
  require file
end

# Loading our router
require './router'

# Loading View Helpers
require './view_helpers'
include ViewHelpers


# Everything past the word layout is in fact the layout.
#  The view gets rendered in the call to yield