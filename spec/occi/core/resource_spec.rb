require "rspec"
require 'occi'

module Occi
  module Core
    describe Resource do

      it "links another resource succesfully" do
        resource = Occi::Core::Resource.new
        target = Occi::Core::Resource.new
        # create a random ID as the resource must already exist and therefore must have an ID assigned
        target.id = UUIDTools::UUID.random_create.to_s
        resource.link target
        resource.links.should have(1).link
        resource.links.first.should be_kind_of Occi::Core::Link
        resource.links.first.target.should be target
      end

    end
  end
end
