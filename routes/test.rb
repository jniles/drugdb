
class TestHandler < Sinatra::Base
  get '/hello' do
    "Hi!"
  end
end
