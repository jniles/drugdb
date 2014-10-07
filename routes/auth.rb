require 'pony'

class Auth < Sinatra::Base

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
    "Sent an email to #{params[:email]}..."
    Pony.mail({
	    :to => #{params[:email]},
	    :subject => "Your password for the Planned Parenthood Drug Database has been reset",
	    :body => "Your password has been reset. Please click the link below to access your account and change your password.",
	    :via => :smtp,
	    :via_options => {
		    :address => "127.0.0.1",
		    :port => "8000",
		    :domain => "localhost.localdomain"
	   }
	  })
  end
end
