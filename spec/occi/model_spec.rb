require "rspec"
require 'occi/model'

describe "Model" do

  it "initializes Core Model successfully" do
    model = Occi::Model.new
    model.get_by_id('http://schemas.ogf.org/occi/core#entity').should be_kind_of Occi::Core::Kind
    model.get_by_id('http://schemas.ogf.org/occi/core#resource').should be_kind_of Occi::Core::Kind
    model.get_by_id('http://schemas.ogf.org/occi/core#link').should be_kind_of Occi::Core::Kind
  end

  it "initializes Infrastructure Model successfully" do
    model = Occi::Model.new
    model.register_infrastructure
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure#compute').should be_kind_of Occi::Core::Kind
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure#os_tpl').should be_kind_of Occi::Core::Mixin
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure#resource_tpl').should be_kind_of Occi::Core::Mixin
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure#network').should be_kind_of Occi::Core::Kind
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure/network#ipnetwork').should be_kind_of Occi::Core::Mixin
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure#networkinterface').should be_kind_of Occi::Core::Kind
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure/networkinterface#ipnetworkinterface').should be_kind_of Occi::Core::Mixin
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure#storage').should be_kind_of Occi::Core::Kind
    model.get_by_id('http://schemas.ogf.org/occi/infrastructure#storagelink').should be_kind_of Occi::Core::Kind
  end

  it "returns all registered categories" do
    model = Occi::Model.new
    collection = model.get
    collection.kind_of? Occi::Collection
    collection.kinds.should have(3).kinds
    collection.mixins.should be_empty
    collection.actions.should be_empty
    collection.resources.should be_empty
    collection.links.should be_empty
  end

  it "returns categories with filter" do
    model = Occi::Model.new
    model.register_infrastructure
    compute = Occi::Core::Kind.new('http://schemas.ogf.org/occi/infrastructure#','compute')
    ipnetwork = Occi::Core::Mixin.new('http://schemas.ogf.org/occi/infrastructure/network#','ipnetwork')
    filter = Occi::Collection.new
    filter.kinds << compute
    filter.mixins << ipnetwork
    collection = model.get(filter)
    collection.kind_of? Occi::Collection
    collection.kinds.first.attributes.should be_kind_of Occi::Core::Attributes
    collection.mixins.first.attributes.should be_kind_of Occi::Core::Attributes
    collection.actions.should be_empty
    collection.resources.should be_empty
    collection.links.should be_empty
  end

end