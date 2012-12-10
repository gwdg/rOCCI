require 'rspec'
require 'occi'

module Occi
  module Api
    module Client

      describe ClientHttp do
        describe "using media type text/plain" do

          before(:all) do


            @client = Occi::Api::Client::ClientHttp.new(
             'http://141.5.99.69', #141.5.99.69 #141.5.99.82
             { :type  => "none" },
             { :out   => "/dev/null",
               :level => Occi::Log::DEBUG },
             true,
             "application/occi+json"#"text/plain,text/occi"
            )





            #@client = Occi::Api::Client::ClientAmqp.new("http://141.5.99.83/", auth_options = { :type => "none" },
            #                                            log_options = { :out => STDERR, :level => Occi::Log::WARN, :logger => nil },
            #                                            media_type = "application/occi+json")
          end

          after(:each) do
            @client.logger.close
          end

          describe "Retrieving all OCCI Categories supported by the OCCI Server" do
            it "should establish connection" do
              @client.connected.should be_true
            end

            it "should have HTTP(200) OK response" do
              @client.last_response.code.should == 200
            end

            it "should have the same Content Type like the HTTP Accept header" do
              @client.last_response.content_type.should == @client.media_type
            end

            it "should contains all supported OCCI Categories" do
              @client.model.actions.should have_at_least(3).actions
              @client.model.kinds  .should have_at_least(3).kinds
              @client.model.mixins .should have_at_least(3).mixins
            end

            it "should contains the basic kinds (entity, resource, link)" do
              entity = nil
              @client.model.kinds.each do |kind|
                if kind.term = "entity"
                  entity = kind
                  break
                end
              end
              entity.should_not == nil

              resource = nil
              @client.model.kinds.each do |kind|
                if kind.term = "resource"
                  resource = kind
                  break
                end
              end
              resource.should_not == nil

              link = nil
              @client.model.kinds.each do |kind|
                if kind.term = "link"
                  link = kind
                  break
                end
              end
              link.should_not == nil
            end
          end

          #TD/OCCI/CORE/DISCOVERY/002
          describe "Retrieving the OCCI Categories with an OCCI Category filter from the OCCI Server" do
            it "should establish connection" do
              @client.connected.should be_true
            end
          end

          #TD/OCCI/CORE/CREATE/001
          describe "Create an OCCI Resource" do
            it "should send a HTTP POST request" do
              res = Occi::Infrastructure::Compute.new
              res.title = "MyComputeResource1"
              #
              @@uri_new = @client.create res
            end

            it "should receipt a HTTP 201 (CREATED) response" do
              @client.last_response.code.should == 201
            end

            it "should receipt the Location of the created OCCI Resource" do
              @@uri_new.should include('/compute/')
            end
          end

          #TD/OCCI/CORE/CREATE/002
          describe "Create an OCCI Resource with an OCCI Mixin" do
            it "should send a HTTP POST request" do
              res = Occi::Infrastructure::Compute.new
              res.title = "MyComputeResource1"
              res.mixins << @client.find_mixin('small', "resource_tpl")
              res.mixins << @client.find_mixin('my_os', "os_tpl")
              #
              @@uri_new = @client.create res
            end

            it "should receipt a HTTP 201 (CREATED) response" do
              @client.last_response.code.should == 201
            end

            it "should have the Mixin inside the created Resource after describe these" do
              @@uri_new.should include('/compute/')
              res = @client.describe @@uri_new
            end
          end

          #TD/OCCI/CORE/CREATE/003
          describe "Create an OCCI Resource with a link to an existing OCCI Resource" do
            it "should send a HTTP POST request" do

            end

            it "should receipt a HTTP 201 (CREATED) response" do

            end

            it "should have the Link to the existing Resource inside the created Resource after describe these" do

            end
          end

          #TD/OCCI/CORE/READ/001
          describe "Retrieve the URLs of all OCCI Resources belonging to an OCCI Kind" do
            it "should send a HTTP GET request" do

            end

            it "should receipt a HTTP 200 (OK) response" do

            end

            it "should displays the URLs of the OCCI Resources" do

            end
          end

          #TD/OCCI/CORE/READ/002
          describe "Retrieve the URLs of the OCCI Resources belonging to an OCCI Kind and related to an OCCI Category filter" do
            it "should send a HTTP GET request" do

            end

            it "should receipt a HTTP 200 (OK) response" do

            end

            it "should only displays the URLs of the OCCI Resources which are related to the OCCI Kind or OCCI Mixin specified as filter" do

            end
          end

          #TD/OCCI/CORE/READ/003
          describe "Retrieve the URLs of the OCCI Resources belonging to an OCCI Kind which contain a specific Attribute" do
            it "should send a HTTP GET request" do

            end

            it "should receipt a HTTP 200 (OK) response" do

            end

            it "should only displays the URLs of the OCCI Resources which contain the specified attribute" do

            end
          end

          #TD/OCCI/CORE/READ/004
          describe "Retrieve the URLs of all OCCI Resources belonging to an OCCI Kind or Mixin" do
            it "should send a HTTP GET request" do

            end

            it "should receipt a HTTP 200 (OK) response" do

            end

            it "should displays the URLs of the OCCI Resources which belong to the OCCI Kind or OCCI Mixin" do

            end
          end

          #TD/OCCI/CORE/READ/005
          describe "Retrieve the description of an OCCI Resource" do
            it "should send a HTTP GET request" do

            end

            it "should receipt a HTTP 200 (OK) response" do

            end

            it "should displays the description of the OCCI Resource" do

            end
          end

          #TD/OCCI/CORE/READ/006
          describe "Retrieve the descriptions of the OCCI Resources belonging to an OCCI Kind and related to an OCCI Category filter" do
            it "should send a HTTP GET request" do

            end

            it "should receipt a HTTP 200 (OK) response" do

            end

            it "should only displays the descriptions of the OCCI Resources which are related to the OCCI Kind or OCCI Mixin specified as filter" do

            end
          end

          #TD/OCCI/CORE/READ/007
          describe "Retrieve the descriptions of the OCCI Resources belonging to an OCCI Kind and containing the Attribute filter" do
            it "should send a HTTP GET request" do

            end

            it "should receipt a HTTP 200 (OK) response" do

            end

            it "should only displays the descriptions of the OCCI Resources which contain the specified attribute" do

            end
          end

          #TD/OCCI/CORE/UPDATE/001
          describe "Full update of a specific OCCI Resource" do
            it "should send a HTTP PUT request" do

            end

            it "should displays success of update operation" do

            end

            it "should replaced the description of the OCCI Resource on the OCCI Server" do

            end
          end

          #TD/OCCI/CORE/DELETE/002
          describe "Delete all OCCI Resources belonging to an OCCI Kind" do
            it "should send a HTTP DELETE request" do
              @client.delete "compute"
            end

            it "should receipt a HTTP 200 (OK) response" do
              @client.last_response.code.should == 200
            end

            it "should has deleted all OCCI Resource belonging to the OCCI Kind" do
              uri_list = @client.list "compute"
              uri_list.should be_empty
            end
          end
        end
      end
    end
  end
end




=begin
        it "should create a compute resource" do
          @client.get_resource "compute"
          @client.get_resource "http://schemas.ogf.org/occi/infrastructure#compute"
        end

        it "should create a network resource" do
          @client.get_resource "network"
          @client.get_resource "http://schemas.ogf.org/occi/infrastructure#network"
        end

        it "should create a storage resource" do
          @client.get_resource "storage"
          @client.get_resource "http://schemas.ogf.org/occi/infrastructure#storage"
        end

        it "should list all available resource types" do
          @client.get_resource_types
        end

        it "should list all available resource type identifiers" do
          @client.get_resource_type_identifiers
        end

        it "should list all available mixin types" do
          @client.get_mixin_types
        end

        it "should list all available mixin type identifiers" do
          @client.get_mixin_type_identifiers
        end

        it "should list compute resources" do
          @client.list "compute"
        end

        it "should list network resources" do
          @client.list "network"
        end

        it "should list storage resources" do
          @client.list "storage"
        end

        it "should list all available mixins" do
          @client.get_mixins
        end

        it "should list os_tpl mixins" do
          @client.get_mixins "os_tpl"
        end

        it "should list resource_tpl mixins" do
          @client.get_mixins "resource_tpl"
        end

        it "should describe compute resources" do
          @client.describe "compute"
        end

        it "should describe network resources" do
          @client.describe "network"
        end

        it "should describe storage resources" do
          @client.describe "storage"
        end

        it "should describe all available mixins" do
          @client.get_mixins.each do |mixin|
            mixin_short = mixin.split("/").last
            @client.find_mixin mixin_short.split("#").last, mixin_short.split("#").first, true
          end
        end

        it "should describe os_tpl mixins" do
          @client.get_mixins("os_tpl").each do |mixin|
            mixin_short = mixin.split("/").last
            @client.find_mixin mixin_short.split("#").last, "os_tpl", true
          end
        end

        it "should describe resource_tpl mixins" do
          @client.get_mixins("resource_tpl").each do |mixin|
            mixin_short = mixin.split("/").last
            @client.find_mixin mixin_short.split("#").last, "resource_tpl", true
          end
        end

        it "should create a new compute resource" do
        end

        it "should create a new storage resource" do
          # TODO
        end

        it "should create a new network resource" do
          # TODO
        end

        it "should deploy an instance based on OVF/OVA file" do
          # TODO
        end

        it "should delete a compute resource" do
        end

        it "should delete a network resource" do
          # TODO
        end

        it "should delete a storage resource" do
          # TODO
        end

        it "should trigger an action on a compute resource" do
          # TODO
        end

        it "should trigger an action on a storage resource" do
          # TODO
        end

        it "should trigger an action on a network resource" do
          # TODO
        end

        it "should refresh its model" do
          @client.refresh
        end

      end

    end
=end
=begin
    describe ClientHttp do

      describe "using media type application/occi+json" do

        use_vcr_cassette "client_http_application_occi_json"

        before(:each) do
          #@client = Occi::Api::ClientHttp.new(
          #  'https://localhost:3300',
          #  { :type  => "none" },
          #  { :out   => "/dev/null",
          #    :level => Occi::Log::DEBUG },
          #  true,
          #  "application/occi+json"
          #)
        end

        it "should establish connection" do
          # TODO
        end

        it "should list compute resources" do
        end

        it "should list network resources" do
        end

        it "should list storage resources" do
        end

        it "should list all available mixins" do
        end

        it "should list os_tpl mixins" do
        end

        it "should list resource_tpl mixins" do
        end

        it "should describe compute resources" do
        end

        it "should describe network resources" do
        end

        it "should describe storage resources" do
        end

        it "should describe all available mixins" do
        end

        it "should describe os_tpl mixins" do
        end

        it "should describe resource_tpl mixins" do
        end

        it "should create a new compute resource" do
        end

        it "should create a new storage resource" do
        end

        it "should create a new network resource" do
        end

        it "should delete a compute resource" do
        end

        it "should delete a network resource" do
        end

        it "should delete a storage resource" do
        end

        it "should trigger an action on a compute resource" do
        end

        it "should trigger an action on a storage resource" do
        end

        it "should trigger an action on a network resource" do
        end

        it "should refresh its model" do
        end

      end

    end

    end
  end
end
=end

