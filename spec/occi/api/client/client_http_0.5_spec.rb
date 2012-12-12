require 'rspec'
require 'occi'

module Occi
  module Api
    module Client

      describe ClientHttp do

        it "should do something" do

          # TODO: Implement scenarios for client
        end
=begin
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
=end
      end
    end
  end
end
