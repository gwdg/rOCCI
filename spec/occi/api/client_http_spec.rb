require 'rspec'
require 'occi'

module Occi
  module API

    describe ClientHttp do

      context "using media type text/plain" do
        use_vcr_cassette "client_http_text_plain"

        it "should establish connection" do
          expect{Occi::API::conn_helper}.to_not raise_error
        end

        it "should create a compute resource" do
          client = Occi::API::conn_helper

          client.get_resource "compute"
          client.get_resource "http://schemas.ogf.org/occi/infrastructure#compute"
        end

        it "should create a network resource" do
          client = Occi::API::conn_helper

          client.get_resource "network"
          client.get_resource "http://schemas.ogf.org/occi/infrastructure#network"
        end

        it "should create a storage resource" do
          client = Occi::API::conn_helper

          client.get_resource "storage"
          client.get_resource "http://schemas.ogf.org/occi/infrastructure#storage"
        end

        it "should list all available resource types" do
          client = Occi::API::conn_helper

          client.get_resource_types
        end

        it "should list all available resource type identifiers" do
          client = Occi::API::conn_helper

          client.get_resource_type_identifiers
        end

        it "should list all available mixin types" do
          client = Occi::API::conn_helper

          client.get_mixin_types
        end

        it "should list all available mixin type identifiers" do
          client = Occi::API::conn_helper

          client.get_mixin_type_identifiers
        end

        it "should list compute resources" do
          client = Occi::API::conn_helper

          expect{client.list "compute"}.to_not raise_error
        end

        it "should list network resources" do
          client = Occi::API::conn_helper

          expect{client.list "network"}.to_not raise_error
        end

        it "should list storage resources" do
          client = Occi::API::conn_helper

          expect{client.list "storage"}.to_not raise_error
        end

        it "should list all available mixins" do
          client = Occi::API::conn_helper

          expect{client.get_mixins}.to_not raise_error
        end

        it "should list os_tpl mixins" do
          client = Occi::API::conn_helper

          expect{client.get_mixins "os_tpl"}.to_not raise_error
        end

        it "should list resource_tpl mixins" do
          client = Occi::API::conn_helper

          expect{client.get_mixins "resource_tpl"}.to_not raise_error
        end

        it "should describe compute resources" do
          client = Occi::API::conn_helper

          expect{client.describe "compute"}.to_not raise_error
        end

        it "should describe network resources" do
          client = Occi::API::conn_helper

          expect{client.describe "network"}.to_not raise_error
        end

        it "should describe storage resources" do
          client = Occi::API::conn_helper

          expect{client.describe "storage"}.to_not raise_error
        end

        it "should describe all available mixins" do
          client = Occi::API::conn_helper
        end

        it "should describe os_tpl mixins" do
          client = Occi::API::conn_helper
        end

        it "should describe resource_tpl mixins" do
          client = Occi::API::conn_helper
        end

        it "should create a new compute resource" do
          client = Occi::API::conn_helper
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
          client = Occi::API::conn_helper
          expect{client.refresh}.to_not raise_error
        end
      end

      context "using media type application/occi+json" do
        use_vcr_cassette "client_http_application_occi_json"

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
