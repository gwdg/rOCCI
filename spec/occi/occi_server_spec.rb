require 'occi/occi-server'
require 'rspec'
require 'rack/test'

VERSION_NUMBER=0.5

module OCCI
  describe OCCIServer do
    include Rack::Test::Methods
    def app
      OCCIServer
    end

    it "serves registered categories through discovery interface" do
      get '/-/'
      last_response.should be_ok
      last_response.body.should include('Category')
    end
  end
end