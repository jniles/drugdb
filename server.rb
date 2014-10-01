#!/usr/bin/env ruby -I ../lib -I lib
require 'sinatra'
require 'sinatra/content_for'
require 'active_record'
require 'chartkick'
require 'warden'

require_relative 'models/init.rb'

# routes 
require_relative 'routes/auth.rb'

module SST
  class App < Sinatra::Base
    enable :sessions

    use Warden::Manager do |config|
      # serialize user to session ->
      config.serialize_into_session{|user| user.id}
      # serialize user from session <-
      config.serialize_from_session{|id| User.get(id)}
      # configuring strategies
      config.scope_defaults :default,
                    strategies: [:password],
                    action: 'auth/unauthenticated'
      config.failure_app = self
    end

    Warden::Manager.before_failure do |env,opts|
      env['REQUEST_METHOD'] = 'POST'
    end

    Warden::Strategies.add(:password) do
      # valid params for authentication
      def valid?
        puts "Testing ... #{params}"
        params['username'] && params['password']
      end

      # authenticating a user
      def authenticate!
        # find for user
        user = User.first(name: params['username'])
        if user.nil?
            puts "[AUTH] No user!"
            fail!("Invalid credentials: user does not exist.")
        elsif user.authenticate(params['password'])
          puts "[AUTH] Login success!"
          success!(user)
        else
          puts "[AUTH] Login error!"
          fail!("An error occurred.  Please try again.")
        end
      end
    end

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
