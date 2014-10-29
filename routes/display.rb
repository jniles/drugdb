class Display < Sinatra::Base
	get "/test" do
		@cpts = Cpt.all
		erb :test
  end
end
