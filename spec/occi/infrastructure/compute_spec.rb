require 'rspec'
require 'occi'

module Occi
  module Infrastructure
    describe Compute do

      it "should create a storagelink to an existing storage resource" do
        compute = Occi::Infrastructure::Compute.new
        target = Occi::Infrastructure::Storage.new
        # create a random ID as the storage resource must already exist and therefore must have an ID assigned
        target.id = UUIDTools::UUID.random_create.to_s
        compute.storagelink target
        compute.links.should have(1).link
        compute.links.first.should be_kind_of Occi::Infrastructure::Storagelink
        compute.links.first.target.should be target
      end

      it "should create a networkinterface to an existing network resource" do
        compute = Occi::Infrastructure::Compute.new
        target = Occi::Infrastructure::Network.new
        # create a random ID as the network resource must already exist and therefore must have an ID assigned
        target.id = UUIDTools::UUID.random_create.to_s
        compute.networkinterface target
        compute.links.should have(1).link
        compute.links.first.should be_kind_of Occi::Infrastructure::Networkinterface
        compute.links.first.target.should be target
      end

    end
  end
end