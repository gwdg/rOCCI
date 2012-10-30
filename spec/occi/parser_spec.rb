require "rspec"
require 'occi'

describe "Parser" do

  it "should parse Occi message with entity in text plain format" do
    media_type    = 'text/plain'
    body          = %Q|Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"\nX-OCCI-Attribute: occi.compute.cores=2|
    _, collection = Occi::Parser.parse(media_type, body)
    collection.should be_kind_of Occi::Collection
    compute_resources = collection.resources.select { |resource| resource.kind.to_s =='http://schemas.ogf.org/occi/infrastructure#compute' }
    compute_resources.should have(1).compute_resource
    compute_resources.first.attributes.occi!.compute!.cores.should == 2
  end

  it "should parse Occi message with entity in JSON format" do
    media_type    = 'application/occi+json'
    body          = File.read('spec/occi/test.json')
    _, collection = Occi::Parser.parse(media_type, body)
    compute_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#compute' }
    compute_resources.should have(1).compute_resource
    compute_resources.first.attributes.occi!.compute!.cores.should == 1
    compute_resources.first.attributes.occi!.compute!.memory.should == 256
    compute_resources.first.links.should have(1).link
  end

  it "should parse an OVF file" do
    media_type        = 'application/ovf+xml'
    body              = File.read('spec/occi/test.ovf')
    _, collection     = Occi::Parser.parse(media_type, body)
    storage_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#storage' }
    storage_resources.should have(1).storage_resource
    storage_resources.first.title.should == 'lamp'
    network_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#network' }
    network_resources.should have(1).network_resource
    network_resources.first.title.should == 'VM Network'
    compute_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#compute' }
    compute_resources.should have(1).compute_resource
    compute_resources.first.attributes.occi!.compute!.cores.should == 1
    compute_resources.first.attributes.occi!.compute!.memory.should == 256
  end

  it "should parse an OVA container" do
    media_type            = 'application/ova'
    body                  = File.read('spec/occi/test.ova')
    locations, collection = Occi::Parser.parse(media_type, body)
    storage_resources     = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#storage' }
    storage_resources.should have(1).storage_resource
    storage_resources.first.title.should == 'lamp'
    network_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#network' }
    network_resources.should have(1).network_resource
    network_resources.first.title.should == 'VM Network'
    compute_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#compute' }
    compute_resources.should have(1).compute_resource
    compute_resources.first.attributes.occi!.compute!.cores.should == 1
    compute_resources.first.attributes.occi!.compute!.memory.should == 256
  end
end