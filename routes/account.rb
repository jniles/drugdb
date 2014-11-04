class Accounts < Sinatra::Base

  #
  # Account Routes
  #

  set :views, Dir.pwd + "/views"

  get '/account/reset' do
    erb :"account/reset", :locals => { :error => 0 }
  end
  
  post '/account/reset' do
    # find the appropriate user
    user =  User.first(:email => params[:email])
    if user
      uuid = securerandom.uuid
      user.update({ :reset_uuid => uuid, :reset_time => Date.new })
      p uuid
      Pony.mail({
        :to => params[:email],
        :subject => "Your password for the Planned Parenthood Drug Database has been reset",
        :body => "Your password has been reset to x. Please click the link below to access your account and change your password.",
        :via => :sendmail
      })
    else
      erb "account/reset", :locals => { :email => params[:email] }
    end
  end
end
