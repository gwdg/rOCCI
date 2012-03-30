require 'occi/occi-server'
require 'rspec'
require 'rack/test'
require 'logger'

VERSION_NUMBER=0.5

describe OCCIServer do
  include Rack::Test::Methods

  def app
    OCCIServer.new({:log_level => Logger::UNKNOWN})
  end

  it "serves registered categories through discovery interface" do
    get '/-/'
    last_response.should be_ok
    last_response.body.should include('Category')
  end

  it "creates new compute resource" do
    headers = {:accept => "text/uri-list"}
    body = %Q{Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind";}
    body += %Q{\nX-OCCI-Attribute: occi.compute.cores=2}
    body += %Q{\nX-OCCI-Attribute: occi.compute.hostname="mycompute.example.com"}
    post '/compute/', body, headers
    last_response.should be_ok
    last_response.body.should include('Location')
  end

end
