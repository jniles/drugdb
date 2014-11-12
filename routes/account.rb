require 'securerandom'

# FIXME
#   This module is a duplication of Vinushka's work, before he pushed his
#   email work.  It should all be removed, once we know all the concepts
#   have been covered.
class Accounts < Sinatra::Base

  #
  # Account Routes
  #

  set :views, Dir.pwd + "/views"

  get '/account/reset' do
    erb :"account/reset", :locals => { :error => nil }
  end

  post '/account/reset' do
    # find the appropriate user
    user =  User.first(:email => params[:email])
    if user
      uuid = SecureRandom.uuid
      user.update({ :reset_uuid => uuid, :reset_time => Date.new })
      p uuid
      Pony.mail({
        :to => params[:email],
        :subject => "Your password for the Planned Parenthood Drug Database has been reset",
        :body => "Your password has been reset to x. Please click the link below to access your account and change your password.",
        :via => :sendmail
      })
      erd :"account/confirmation", :locals => { :email => params[:email] }
    else
      erb :"account/reset", :locals => { :error => params[:email] }
    end
  end
end
