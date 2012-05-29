require 'rspec'
require 'rspec/http'
require 'rack/test'
require 'logger'
require 'json'
require 'uri'

require 'occi/server'
require 'occi/registry'

VERSION_NUMBER=0.5

describe OCCI::Server do
  include Rack::Test::Methods

  def app
    OCCI::Server
  end

  describe "Model" do

    it "initializes Core Model successfully" do
      OCCI::Server.initialize_core_model
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/core#entity').should be_kind_of OCCI::Core::Kind
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/core#resource').should be_kind_of OCCI::Core::Kind
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/core#link').should be_kind_of OCCI::Core::Kind
    end

    it "initializes Infrastructure Model successfully" do
      OCCI::Server.initialize_model('etc/model/infrastructure/')
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

    it "initializes Model Extensions successfully" do
      OCCI::Server.initialize_model('etc/model/extensions/')
      OCCI::Registry.get_by_id('http://schemas.ogf.org/occi/infrastructure/compute#console').should be_kind_of OCCI::Core::Kind
    end

    it "initializes OpenNebula Model Extensions successfully" do
      OCCI::Server.initialize_model('etc/backend/opennebula/model/')
      OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#compute').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#storage').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#storagelink').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#network').should be_kind_of OCCI::Core::Mixin
      OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#networkinterface').should be_kind_of OCCI::Core::Mixin
    end

    #it "initializes OpenNebula Templates successfully" do
    #  OCCI::Server.initialize_model('etc/backend/opennebula/templates')
    #  OCCI::Registry.get_by_id('http://opennebula.org/occi/infrastructure#virtualmachine').should be_kind_of OCCI::Core::Mixin
    #end

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
    it "creates a new compute resource with a request in plain text format" do
      header "Accept", "text/uri-list"
      header "Content-type", "text/plain"
      body = %Q{Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"}
      body += %Q{\nX-OCCI-Attribute: occi.compute.cores=2}
      post '/compute/', body
      last_response.should be_http_created
    end

    it "creates a new compute resource with a request in json format" do
      header "Accept", "text/uri-list"
      header "Content-type", "application/occi+json"
      body = %Q|{"resources":[{"attributes":{"occi":{"compute":{"cores":2}}},"kind":"http://schemas.ogf.org/occi/infrastructure#compute"}]}|
      post '/compute/', body
      last_response.should be_http_created
    end
  end

  describe "GET /compute/" do
    it "gets all compute resources" do
      header "Accept", "text/uri-list"
      get '/compute/'
      last_response.should be_http_ok
      last_response.body.lines.count.should == 2
    end
  end

  describe "GET /compute/$uuid" do
    it "gets specific compute resource in text/plain format" do
      header "Accept", "text/uri-list"
      get '/compute/'
      last_response.should be_http_ok
      location = URI.parse(last_response.body.lines.to_a.last)
      header "Accept", "text/plain"
      get location.path
      last_response.should be_http_ok
      last_response.body.should include('scheme="http://schemas.ogf.org/occi/infrastructure#"')
    end
  end

  describe "GET /compute/$uuid" do
    it "gets specific compute resource in application/json format" do
      header "Accept", "text/uri-list"
      get '/compute/'
      last_response.should be_http_ok
      location = URI.parse(last_response.body.lines.to_a.last)
      header "Accept", "application/occi+json"
      get location.path
      last_response.should be_http_ok
      collection = Hashie::Mash.new(JSON.parse(last_response.body))
      collection.resources.first.kind.should == 'http://schemas.ogf.org/occi/infrastructure#compute'
    end
  end

  describe "POST /compute/$uuid?action=X" do
    it "triggers applicable action on a previously created compute resource" do
      header "Content-type", ''
      header "Accept", "text/uri-list"
      get '/compute/'
      last_response.should be_http_ok
      location = URI.parse(last_response.body.lines.to_a.last)
      header "Accept", "application/occi+json"
      get location.path
      last_response.should be_http_ok
      collection = Hashie::Mash.new(JSON.parse(last_response.body))
      action_location = collection.resources.first.links.first.target
      puts action_location
      post action_location
      last_response.should be_http_ok
    end
  end

  describe "POST /storage/" do
    it "creates a new storage resource with a request in plain text format" do
      header "Accept", "text/uri-list"
      header "Content-type", "text/plain"
      body = %Q{Category: storage; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"}
      body += %Q{\nX-OCCI-Attribute: occi.storage.size=2}
      post '/storage/', body
      last_response.should be_http_created
    end

    it "creates a new storage resource with a request in plain text format" do
      header "Accept", "text/uri-list"
      header "Content-type", "application/occi+json"
      body = %Q|{"resources":[{"attributes":{"occi":{"storage":{"size":2}}},"kind":"http://schemas.ogf.org/occi/infrastructure#storage"}]}|
      post '/storage/', body
      last_response.should be_http_created
    end
  end

  describe "DELETE /compute/" do
    it "deletes all compute resources" do
      header "Content-type", ''
      delete '/compute/'
      last_response.should be_http_ok
      header "Accept", "text/uri-list"
      get '/compute/'
      last_response.should be_http_ok
      last_response.body.should be_empty
    end
  end

  describe "DELETE /" do
    it "deletes all resources" do
      header "Content-type", ''
      delete '/'
      last_response.should be_http_ok
      header "Accept", "text/uri-list"
      get '/storage/'
      last_response.should be_http_ok
      last_response.body.should be_empty
    end
  end

end
