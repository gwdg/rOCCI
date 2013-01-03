require 'rspec'
require 'occi'

module Occi
  describe Collection do

    it "should create a new Occi collection including the Occi base objects" do
      collection = Occi::Collection.new
      collection.kinds << "http://schemas.ogf.org/occi/infrastructure#compute"
      collection.mixins << "http://example.com/occi/tags#my_mixin"
      collection.actions << "http://schemas.ogf.org/occi/infrastructure/compute/action#start"
      collection.action = Occi::Core::Action_instance.new
      collection.resources << Occi::Core::Resource.new
      collection.links << Occi::Core::Link.new
      collection.kinds.first.should be_kind_of Occi::Core::Kind
      collection.mixins.first.should be_kind_of Occi::Core::Mixin
      collection.actions.first.should be_kind_of Occi::Core::Action
      collection.resources.first.should be_kind_of Occi::Core::Resource
      collection.links.first.should be_kind_of Occi::Core::Link
      collection.action.should be_kind_of Occi::Core::Action_instance
    end

    it "registers a model, creates a new OCCI Resource and checks it against the model" do
      collection = Occi::Collection.new
      collection.model.should be_kind_of Occi::Model
      collection.resources.create 'http://schemas.ogf.org/occi/core#resource'
      collection.resources.first.should be_kind_of Occi::Core::Resource
      expect { collection.check }.to_not raise_error
    end

    it 'successfully gets all categories related to a category' do
      collection = Occi::Collection.new
      collection.kinds << Occi::Core::Resource.kind
      collection.kinds << Occi::Core::Link.kind
      collection.get_related_to(Occi::Core::Entity.kind).should == collection
      collection.get_related_to(Occi::Core::Resource.kind).kinds.first.should == Occi::Core::Resource.kind
      collection.get_related_to(Occi::Core::Link.kind).kinds.first.should == Occi::Core::Link.kind
    end

  end
end