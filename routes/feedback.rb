require 'pony'
#
# Feedback Routes
#
class Feedback < Sinatra::Base
  set :views, Dir.pwd + '/views'

  FEEDBACKEMAIL = File.join(CONFIG['install_dir'], 'mail/users/feedback.erb')

  # We run into issues with non-valid UTF characters (actually, UTF-16),
  # so we need to transform a string into UTF-8 from UTF-8 to ensure they
  # are rendered and written properly.
  def escape(string)
    if String.method_defined?(:encode)
      string.encode!('UTF-16', 'UTF-8', invalid: :replace, replace: '')
      string.encode!('UTF-8', 'UTF-16')
    else
      ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
      string = ic.iconv(string)
    end
  end

  get '/feedback' do
    env['warden'].authenticate!

    erb :'feedback/form'
  end

  post '/feedback/submit' do
    env['warden'].authenticate!

    data = {
      user: env['warden'].user,
      comments: params[:comments]
    }

    # template the email data
    templateString = File.read(FEEDBACKEMAIL)
    template = ERB.new(templateString).result(binding)

    # set the mail server parameters (from config.yaml)
    message_params= {
	    from: CONFIG['email'][0]['sender'], #YAML syntax quirk - when you make a hash, you get a list of hashes with one element. Why? Because Ruby.
      to: CONFIG['email'][0]['admin'],
      subject: "[Drug Inventory] #{ data[:user].name } provided some feedback.",
      html_body: escape(template)
    }

    # if we have specified the 'via' methods for delivery,
    # make sure to pass those to Pony
    if CONFIG['email'][0]['via']
      message_params[:via] = CONFIG['email'][0]['via']
      message_params[:via_options] = CONFIG['email'][0]['via_options'][0]
    end

    # send the email via Pony gem
    Pony.mail(message_params)

    erb :'feedback/thanks'
  end
end
