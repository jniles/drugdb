require 'securerandom'
require 'pony'

# Invalid UTF-8 sequences in the email file(s) require this soln
require 'iconv' unless String.method_defined?(:encode)

PASSWORDEMAIL = '/home/jniles/code/drugdb/email/password.reset.erb';

# FIXME
#   This module is a duplication of Vinushka's work, before he pushed his
#   email work.  It should all be removed, once we know all the concepts
#   have been covered.
class Accounts < Sinatra::Base

  #
  # Account Routes
  #

  def escape(string)
    if String.method_defined?(:encode)
        string.encode!('UTF-8', 'UTF-8', :invalid => :replace)
    else
        ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
        string = ic.iconv(file_contents)
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
      end

      # compose the email
      url = "http://localhost:#{settings.port}/account/change/#{new_uuid}"

      templateString = File.read(PASSWORDEMAIL)
      data = { :url => url, :user => user.name, :email => params[:email] }
      template = ERB.new(templateString).result(binding)

      # send the email
      Pony.mail({
        :from => "admin@drugdb",
        :to => params[:email],
        :subject => "Password Reset Request",
        :html_body => escape(template),
        :via => :smtp,
        :via_options => {
          :address => "smtp.ncf.edu",
          :port => "25",
          :authentication => :plain,
          :domain => "10.10.11.15"
        }
      })

      erb :"account/reset_confirmation", :locals => { :data => data }
    end
  end

	get '/account/change/:uuid' do
		user = User.first(:uuid_token => params[:uuid])
		if not user.nil?
		# TODO: Find out how to subtract dates so we can say "UUID less than a week old" or whatever
		# cool, so yours is valid. Display change form...we make it a template so it has the correct links
			@uuid = params[:uuid]
			erb :change
		else
			"The link you provided is either invalid or has expired. If you intended to reset your password and have input this link correctly, please try to <a href='/account/reset/'>reset</a> it again."
		end
	end

	post '/account/change/:uuid' do
		user = User.first(:uuid_token => params[:uuid]) #check again just in case
		if not user.nil?
			user.update({:password => params[:new_password], :uuid_token => nil, :uuid_date => nil}) #wipe old tokens
			redirect "/"
		else
			"The UUID you have provided is no longer valid. Please try to reset your password again <a href='/account/reset/'>using our automated system.</a>"
		end
		# we do the password matching check in JS, not on the server.
		# now take the new password and shove it in to user
	end
end
