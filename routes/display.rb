class DrugDisplay < Sinatra::Base

	set :views, Dir.pwd + "/views"

	get '/test/display' do
		env['warden'].authenticate!
		@cpts = Cpt.all
		erb :test
  end
end
