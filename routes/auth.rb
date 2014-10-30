require 'pony'
require 'warden'

class Auth < Sinatra::Base

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

  # Login form submits here.
  post '/auth/login' do
    env['warden'].authenticate!
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
     redirect '/login.html'
   end

  get '/auth/logout' do 
    env['warden'].raw_session.inspect
    env['warden'].logout
    redirect '/'
  end

  get '/auth/reset' do
    send_file File.join('public', 'reset.html')
  end
  
  post '/auth/reset' do
    puts "Sending an email to #{params[:email]}..."
    # gets 12 pseudorandom characters in the ASCII A-Z + symbols + a-z range 
    arf =(0...12).map { (65 + rand(56)).chr }.join
    user =  User.first(:email => params[:email])
    user.update({ :password => arf })
    Pony.mail({
	    :to => params[:email],
	    :subject => "Your password for the Planned Parenthood Drug Database has been reset",
	    :body => "Your password has been reset to x. Please click the link below to access your account and change your password.",
	    :via => :sendmail
	  })
  end
end
