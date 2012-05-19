require 'rspec'
require 'rspec/http'
require 'rack/test'
require 'logger'
require 'json'

require 'occi/server'
require 'occi/registry'

VERSION_NUMBER=0.5

describe OCCI::Server do
  include Rack::Test::Methods

  def app
    OCCI::Server
  end

  describe "Model" do

    OCCI::Server.initialize_model

    it "initializes Infrastructure successfully" do
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#compute').should be_kind_of OCCI::Core::Kind
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#os_tpl').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#resource_tpl').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#network').should be_kind_of OCCI::Core::Kind
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure/network#ipnetwork').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#networkinterface').should be_kind_of OCCI::Core::Kind
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure/networkinterface#ipnetworkinterface').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#storage').should be_kind_of OCCI::Core::Kind
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure#storagelink').should be_kind_of OCCI::Core::Kind
    end

    it "initializes Extensions successfully" do
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure/compute#console').should be_kind_of OCCI::Core::Kind
    end

  end

  describe "GET /-/" do

    it "returns registered categories in JSON format" do
      header "Accept", "application/json"
      get '/-/'
      last_response.should be_ok
      collection = Hashie::Mash.new(JSON.parse(last_response.body))
      collection.kinds.should have_at_least(3).kinds
    end

    it "returns registered categories in plain text format " do
      header "Accept", "text/plain"
      get '/-/'
      last_response.should be_ok
      last_response.body.should include('Category')
    end

  end

  describe "POST /compute/" do
    it "creates a new compute resource with plain text format" do
      header "Accept", "text/uri-list"
      header "Content-type", "text/plain"
      body = %Q{Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"}
      body += %Q{\nX-OCCI-Attribute: occi.compute.cores=2}
      post '/compute/', body
      last_response.should be_http_created
    end

    it "creates a new compute resource with json format" do
      header "Accept", "text/uri-list"
      header "Content-type", "application/occi+json"
      body = %Q|{"resources":[{"attributes":{"occi":{"compute":{"cores":2,"architecture":"x86"}}},"kind":"http://schemas.ogf.org/occi/infrastructure#compute"}]}|
      post '/compute/', body
      last_response.should be_http_created
    end
  end

  describe "GET /compute/" do
    it "gets all compute resources" do
      header "Accept", "text/uri-list"
      get '/compute/'
      last_response.should be_http_ok
      last_response.body.lines.count.should >= 1
    end
  end

  describe "DELETE /compute/" do
    it "deletes all compute resources" do
      header "Content-type", ''
      delete '/compute/'
      puts last_response.body
      last_response.should be_http_ok
      header "Accept", "text/uri-list"
      get '/compute/'
      last_response.should be_http_ok
      last_response.body.should be_empty
    end
  end

end
