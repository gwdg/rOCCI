require 'rspec'
require 'occi'

module Occi
  module API

    describe ClientAmqp do

      context "using media type text/plain" do
        use_vcr_cassette "client_amqp_text_plain"

        it "should establish connection" do
          # TODO
        end

        it "should list all available resources" do
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

        it "should describe all available resources" do
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

      context "using media type application/occi+json" do
        use_vcr_cassette "client_amqp_application_occi_json"

        it "should establish connection" do
          # TODO
        end

        it "should list all available resources" do
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

        it "should describe all available resources" do
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
