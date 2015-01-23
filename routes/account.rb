require 'securerandom'
require 'pony'

# Invalid UTF-8 sequences in the email file(s) require this soln
require 'iconv' unless String.method_defined?(:encode)

PASSWORDEMAIL = File.join(CONFIG['email_dir'], 'password.reset.erb')

class Accounts < Sinatra::Base

  #
  # Account Routes
  #

  # We run into issues with non-valid UTF characters (actually, UTF-16),
  # so we need to transform a string into UTF-8 from UTF-8 to ensure they
  # are rendered and written properly.
  def escape(string)
    if String.method_defined?(:encode)
        string.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
        string.encode!('UTF-8', 'UTF-16')
    else
        ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
        string = ic.iconv(string)
    end
  end

  set :views, Dir.pwd + "/views"

  get '/account/reset' do
    erb :"account/reset", :locals => { :error => nil }
  end

  post '/account/reset' do
    user = User.first(:email => params[:email]) #try to find the user

    if user.nil?
      erb :"account/reset", :locals => { :error => params[:email] }
    else
      if not user.uuid_date or user.uuid_date < Date.today
        new_uuid = SecureRandom.uuid
        user.update({ :uuid_token => new_uuid, :uuid_date => Date.today })
      else
        new_uuid = user.uuid_token
      end

      # compose the email
      url = "http://localhost:#{settings.port}/account/change/#{new_uuid}"

      templateString = File.read(PASSWORDEMAIL)
      data = { :url => url, :user => user.name, :email => params[:email] }
      template = ERB.new(templateString).result(binding)

      # compose the email
      message_params= {
        :from => CONFIG["email"]["sender"],
        :to => params[:email],
        :subject => "[DRUGDB] Password Reset Request",
        :html_body => escape(template),
      }

      # if we have specified the "via" methods for delivery,
      # make sure to pass those to Pony
      if CONFIG["email"]["via"]
        message_params["via"] = CONFIG["email"]["via"]
        message_params["via_options"] = CONFIG["email"]["via_options"]
      end

      # send the email
      Pony.mail(message_params)

      erb :"account/reset.confirmation", :locals => { :data => data }
    end
  end

  get '/account/change/:uuid' do
    user = User.first(:uuid_token => params[:uuid])
    if not user.nil?
      @uuid = params[:uuid]
      erb :"account/reset.form", :locals => { :data => { uuid: @uuid } }
    else
      url = "http://localhost:#{settings.port}/account/reset"
      erb :"account/reset.expired", :locals => { :data => { url: url } }
    end
  end

  post '/account/change/:uuid' do
    user = User.first(:uuid_token => params[:uuid])
    if not user.nil?
      # wipe old tokens and set passwd
      user.update({:password => params[:password], :uuid_token => nil, :uuid_date => nil})
      erb :"account/change.success", :locals => { :data => { email: user.email } }
    else
      erb :"account/change.failure", :locals => { :data => { email: params[:uuid] } }
    end
  end
end
