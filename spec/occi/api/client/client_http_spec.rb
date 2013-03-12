require 'rspec'
require 'occi'

module Occi
  module Api
    module Client

    vcr_options = { :record => :new_episodes }
    describe ClientHttp, :vcr => vcr_options do

      context "using media type text/plain" do

        before(:each) do
          @client = Occi::Api::Client::ClientHttp.new({
           :endpoint => 'https://localhost:3300',
           :auth => { :type  => "none" },
           :log => { :out   => "/dev/null",
                     :level => Occi::Log::DEBUG },
           :auto_connect => true,
           :media_type => "text/plain,text/occi"
          })
        end

        after(:each) do
          @client.logger.close if @client && @client.logger
        end

        it "establishes connection" do
          @client.connected.should be_true
        end

        it "instantiates a compute resource using type name" do
          compute = @client.get_resource "compute"
          
          compute.should be_a_kind_of Occi::Core::Resource
          compute.kind.type_identifier.should eq "http://schemas.ogf.org/occi/infrastructure#compute"
        end

        it "instantiates a compute resource using type identifier" do
          compute = @client.get_resource "http://schemas.ogf.org/occi/infrastructure#compute"
          
          compute.should be_a_kind_of Occi::Core::Resource
          compute.kind.type_identifier.should eq "http://schemas.ogf.org/occi/infrastructure#compute"
        end

        it "instantiates a network resource using type name" do
          network = @client.get_resource "network"

          network.should be_a_kind_of Occi::Core::Resource
          network.kind.type_identifier.should eq "http://schemas.ogf.org/occi/infrastructure#network"
        end

        it "instantiates a network resource using type identifier" do
          network = @client.get_resource "http://schemas.ogf.org/occi/infrastructure#network"

          network.should be_a_kind_of Occi::Core::Resource
          network.kind.type_identifier.should eq "http://schemas.ogf.org/occi/infrastructure#network"
        end

        it "instantiates a storage resource using type name" do
          storage = @client.get_resource "storage"

          storage.should be_a_kind_of Occi::Core::Resource
          storage.kind.type_identifier.should eq "http://schemas.ogf.org/occi/infrastructure#storage"
        end

        it "instantiates a storage resource using type identifier" do
          storage = @client.get_resource "http://schemas.ogf.org/occi/infrastructure#storage"

          storage.should be_a_kind_of Occi::Core::Resource
          storage.kind.type_identifier.should eq "http://schemas.ogf.org/occi/infrastructure#storage"
        end

        it "lists all available resource types" do
          @client.get_resource_types.should include("compute", "storage", "network")
        end

        it "lists all available resource type identifiers" do
          @client.get_resource_type_identifiers.should include("http://schemas.ogf.org/occi/infrastructure#compute", "http://schemas.ogf.org/occi/infrastructure#network", "http://schemas.ogf.org/occi/infrastructure#storage")
        end

        it "lists all available entity types" do
          @client.get_entity_types.should include("entity", "resource", "link")
        end

        it "lists all available entity type identifiers" do
          @client.get_entity_type_identifiers.should include("http://schemas.ogf.org/occi/core#entity", "http://schemas.ogf.org/occi/core#resource", "http://schemas.ogf.org/occi/core#link")
        end

        it "lists all available link types" do
          @client.get_link_types.should include("storagelink", "networkinterface")
        end

        it "lists all available link type identifiers" do
          @client.get_link_type_identifiers.should include("http://schemas.ogf.org/occi/infrastructure#storagelink", "http://schemas.ogf.org/occi/infrastructure#networkinterface")
        end

        it "lists all available mixin types" do
          @client.get_mixin_types.should include("os_tpl", "resource_tpl")
        end

        it "lists all available mixin type identifiers" do
          @client.get_mixin_type_identifiers.should include("http://schemas.ogf.org/occi/infrastructure#os_tpl", "http://schemas.ogf.org/occi/infrastructure#resource_tpl")
        end

        it "lists compute resources" do
          @client.list "compute"
        end

        it "lists network resources" do
          @client.list "network"
        end

        it "lists storage resources" do
          @client.list "storage"
        end

        it "lists all available mixins" do
          @client.get_mixins
        end

        it "lists os_tpl mixins" do
          @client.get_mixins "os_tpl"
        end

        it "lists resource_tpl mixins" do
          @client.get_mixins "resource_tpl"
        end

        it "describes compute resources" do
          @client.describe "compute"
        end

        it "describes network resources" do
          @client.describe "network"
        end

        it "describes storage resources" do
          @client.describe "storage"
        end

        it "describes all available mixins" do
          @client.get_mixins.each do |mixin|
            mixin_short = mixin.split("/").last
            @client.find_mixin mixin_short.split("#").last, mixin_short.split("#").first, true
          end
        end

        it "describes os_tpl mixins" do
          @client.get_mixins("os_tpl").each do |mixin|
            mixin_short = mixin.split("/").last
            @client.find_mixin mixin_short.split("#").last, "os_tpl", true
          end
        end

        it "describes resource_tpl mixins" do
          @client.get_mixins("resource_tpl").each do |mixin|
            mixin_short = mixin.split("/").last
            @client.find_mixin mixin_short.split("#").last, "resource_tpl", true
          end
        end

        it "creates a new compute resource"

        it "creates a new storage resource"

        it "creates a new network resource"

        it "deploys an instance based on OVF/OVA file"

        it "deletes a compute resource"

        it "deletes a network resource"

        it "deletes a storage resource"

        it "triggers an action on a compute resource"

        it "triggers an action on a storage resource"

        it "triggers an action on a network resource"

        it "refreshes its model" do
          @client.refresh
        end

      end

      context "using media type application/occi+json" do

        before(:each) do
          #@client = Occi::Api::ClientHttp.new({
          #  :endpoint => 'https://localhost:3300',
          #  :auth => { :type  => "none" },
          #  :log => { :out   => "/dev/null",
          #            :level => Occi::Log::DEBUG },
          #  :auto_connect => true,
          #  :media_type => "application/occi+json"
          #})
        end

        it "establishes connection"

        it "lists compute resources"

        it "lists network resources"

        it "lists storage resources"

        it "lists all available mixins"

        it "lists os_tpl mixins"

        it "lists resource_tpl mixins"

        it "describes compute resources"

        it "describes network resources"

        it "describes storage resources"

        it "describes all available mixins"

        it "describes os_tpl mixins"

        it "describes resource_tpl mixins"

        it "creates a new compute resource"

        it "creates a new storage resource"

        it "creates a new network resource"

        it "deletes a compute resource"

        it "deletes a network resource"

        it "deletes a storage resource"

        it "triggers an action on a compute resource"

        it "triggers an action on a storage resource"

        it "triggers an action on a network resource"

        it "refreshes its model"

      end
    end

    end
  end
end
