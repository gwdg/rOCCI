require "rspec"

require 'occi/rendering/http/LocationRegistry'
require 'logger'

$log = Logger.new(NIL)

module OCCI
  module Rendering
    module HTTP
      describe LocationRegistry do
        describe "new object" do
          it "is registered successfully" do
            location = '/resource/123'
            attributes = Hash.new
            object = OCCI::Core::Resource.new(attributes)
            LocationRegistry.register(location, object)
            LocationRegistry.get_location_of_object(object).should == location
            LocationRegistry.get_object_by_location(location).should == object
            LocationRegistry.get_resources_below_location('/',[OCCI::Core::Resource::KIND]).first.should == object
            LocationRegistry.get_resources_below_location('/resource/',[OCCI::Core::Resource::KIND]).first.should == object
          end
        end
      end
    end
  end
end