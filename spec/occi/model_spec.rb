require "rspec"
require 'occi'

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
    compute = Occi::Infrastructure::Compute.kind
    collection = model.get(compute)
    collection.kind_of? Occi::Collection
    collection.kinds.first.should == compute
    collection.mixins.should have_at_least(2).mixins
    collection.actions.should be_empty
    collection.resources.should be_empty
    collection.links.should be_empty
  end

end