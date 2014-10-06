
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
    "Want to reset your password?"
  end
end
