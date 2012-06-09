require "rspec"
require 'occi/model'

describe "Model" do

  it "initializes Core Model successfully" do
    OCCI::Model.register_core
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/core#entity').should be_kind_of OCCI::Core::Kind
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/core#resource').should be_kind_of OCCI::Core::Kind
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/core#link').should be_kind_of OCCI::Core::Kind
  end

  it "initializes Infrastructure Model successfully" do
    OCCI::Model.register_files('etc/model/infrastructure/')
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#compute').should be_kind_of OCCI::Core::Kind
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#os_tpl').should be_kind_of OCCI::Core::Mixin
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#resource_tpl').should be_kind_of OCCI::Core::Mixin
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#network').should be_kind_of OCCI::Core::Kind
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure/network#ipnetwork').should be_kind_of OCCI::Core::Mixin
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#networkinterface').should be_kind_of OCCI::Core::Kind
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure/networkinterface#ipnetworkinterface').should be_kind_of OCCI::Core::Mixin
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#storage').should be_kind_of OCCI::Core::Kind
    OCCI::Model.get_by_id('http://schemas.ogf.org/occi/infrastructure#storagelink').should be_kind_of OCCI::Core::Kind
  end

end