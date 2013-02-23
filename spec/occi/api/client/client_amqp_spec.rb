require "rspec"
require "occi"

#Todo mock the amqp messages

module Occi
  module Api
    module Client

    describe ClientAmqp do

      context "using media type application/occi+json" do

        it "does something"

      end

      context "using media type text/plain" do

        it "does something"

      end

=begin
      before(:all) do
        @client = Occi::Api::Client::ClientAmqp.new({
          :endpoint => "http://localhost:9292/",
          :auth => { :type => "none" },
          :log => { :out => STDERR, :level => Occi::Log::WARN, :logger => nil },
          :media_type => "application/occi+json"
        })
      end

      it "initialize and connect client" do
        @client.connected.should be_true

        @client.model.actions  .should have_at_least(1).actions
        @client.model.kinds    .should have_at_least(3).kinds
        @client.model.mixins   .should have_at_least(1).mixins
        @client.model.links    .should be_empty
        @client.model.resources.should be_empty

      end

      it "create compute" do
        res = Occi::Infrastructure::Compute.new
        res.title = "MyComputeResource1"
        res.mixins << @client.find_mixin('small', "resource_tpl")
        res.mixins << @client.find_mixin('my_os', "os_tpl")
        #
        uri_new = @client.create res
        uri_new.should include('/compute/')
        @client.last_response_status.should == 201

        res.title = "MyComputeResource2"
        uri_new = @client.create res
        uri_new.should include('/compute/')
        @client.last_response_status.should == 201

      end

      it "list /" do
        list = @client.list
        list.should have_at_least(1).list
      end

      it "list compute" do
        list = @client.list "compute"
        list.should have_at_least(1).list
      end

      it "describe /" do
        description = @client.describe

        description[0].resources.should have_at_least(1).resources
      end

      it "describe compute" do
        description = @client.describe "compute"

        description[0].resources.should have_at_least(1).resources
      end

      it "describe compute/uuid" do
        list = @client.list "compute"
        list.should have_at_least(1).list

        compute = list.first

        description = @client.describe compute

        description[0].resources.should have_at_least(1).resources
        resource = description[0].resources.first

        resource_type_identifier = @client.endpoint.chomp('/') + resource.kind.location + resource.id
        resource_type_identifier.should == compute.to_s
      end

      it "trigger compute stop" do
        list = @client.list "compute"
        list.should have_at_least(1).list

        list.each do |key, value|
          description = @client.describe key
          @compute = key
          @resource    = description[0].resources.first

          if @resource.attributes.occi.compute.state == "active"
            break
          end
        end

        @resource.actions.each do |key , value|
          if key.term == "stop"
            @action = key
            break
          end
        end

        @action.should_not be_nil, "action is nil"
        @action.term.should == "stop"

        @client.trigger(@compute, @action.to_s)

        description = @client.describe @compute
        @resource   = description[0].resources.first

        @resource.attributes.occi.compute.state.should == "inactive"
      end

      it "delete compute/uuid" do
        list = @client.list "compute"
        list_count = list.count
        list_count.should >= 1

        compute = list.first

        response = @client.delete compute
        response.should == true
        @client.last_response_status.should == 200

       list = @client.list "compute"
        list.count.should < list_count
      end

      it "delete /" do
        response = @client.delete "/"
        response.should == true
        @client.last_response_status.should == 200

        list = @client.list "compute"
        list.count.should == 0
      end
=end
    end

    end
  end
end
