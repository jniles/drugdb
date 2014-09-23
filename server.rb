#!/usr/bin/env ruby -I ../lib -I lib
require 'sinatra'
require 'sinatra/content_for'
require 'active_record'
require 'chartkick'
require 'warden'
require 'sinatra/flash'


require_relative 'models/init.rb'

# handlers
require_relative 'routes/test.rb'

module SST
  class App < Sinatra::Base
    enable :sessions
    register Sinatra::Flash

    use TestHandler

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
        params['user'] && params['user']['username'] && params['user']['password']
      end

      # authenticating a user
      def authenticate!
        # find for user
        user = User.first(username: params['user']['username'])
        if user.nil?
            fail!("Invalid credentials: user does not exist.")
            flash.err = ""
        elsif user.authenticate(params['user']['password'])
          flash.success = "Logged in"
          success!(user)
        else
          fail!("An error occurred.  Please try again.")
        end
      end
    end

    get '/' do
      "Hello world"
    end

    post '/' do
      "this is a post"
    end

    # Login form submits here.
    post '/login' do
      puts "username is: #{params[:username]}"
      puts "password is: #{params[:password]}"
      #env['warden'].authenticate!
      if session[:return_to].nil?
        redirect '/'
      else
        redirect session[:return_to]
      end
    end

    # when a user reaches a protected route watched by Warden calls
     post '/auth/unauthenticated' do
       session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
       puts env['warden.options'][:attempted_path]
       puts env['warden']
       flash[:error] = env['warden'].message || "You must log in"
       redirect '/login.html'
     end

    get '/logout' do 
      env['warden'].raw_session.inspect
      env['warden'].logout
      flash[:success] = "Successfully logged out"
      redirect '/'
    end
  end
end
