require 'rspec'
require 'Occi'

module Occi
  describe Collection do
    describe "initialize" do

      it "should create a new Occi collection including the Occi base objects" do
        collection = Hashie::Mash.new(:kinds => [], :mixins => [], :actions => [], :resources => [], :links => [])
        collection.kinds << { :term => "compute", :scheme => "http://schemas.ogf.org/occi/infrastructure#" }
        collection.mixins << { :term => "my_mixin", :scheme => "http://example.com/occi/tags#" }
        collection.actions << { :term => "start", :scheme => "http://schemas.ogf.org/occi/infrastructure/compute/action#" }
        collection.resources << { :kind => "http://schemas.ogf.org/occi/infrastructure#compute" }
        collection.links << { :kind => "http://schemas.ogf.org/occi/infrastructure#storagelink" }
      end

    end
  end
end