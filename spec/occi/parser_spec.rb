require "rspec"
require 'occi'

describe "Parser" do

  it "should parse an OCCI message with MIME type text/plain containing an OCCI resource" do
    # create new collection
    collection = Occi::Collection.new
    # create new resource within collection
    resource = collection.resources.create

    # render collection to text/plain MIME type
    rendered_collection = collection.to_text
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('text/plain',rendered_collection).should == collection

    # add attributes to resource
    resource.id = UUIDTools::UUID.random_create.to_s
    resource.title = 'title'

    # render collection to text/plain MIME type
    rendered_collection = collection.to_text
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('text/plain',rendered_collection).should == collection

    # add mixin to resource
    resource.mixins << Occi::Core::Mixin.new

    # render collection to text/plain MIME type
    rendered_collection = collection.to_text
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('text/plain',rendered_collection).should == collection

    # add link to resource
    link = resource.links.create
    link.target = 'http://example.com/resource/aee5acf5-71de-40b0-bd1c-2284658bfd0e'

    # render collection to text/plain MIME type
    rendered_collection = collection.to_text
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('text/plain',rendered_collection).should == collection
  end

  it "should parse an OCCI message with MIME type application/occi+json containing an OCCI resource" do
    # create new collection
    collection = Occi::Collection.new
    # create new resource within collection
    resource = collection.resources.create

    # render collection to text/plain MIME type
    rendered_collection = collection.to_json
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('application/occi+json',rendered_collection).should == collection

    # add attributes to resource
    resource.id = UUIDTools::UUID.random_create.to_s
    resource.title = 'title'

    # render collection to text/plain MIME type
    rendered_collection = collection.to_json
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('application/occi+json',rendered_collection).should == collection

    # add mixin to resource
    resource.mixins << Occi::Core::Mixin.new

    # render collection to text/plain MIME type
    rendered_collection = collection.to_json
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('application/occi+json',rendered_collection).should == collection

    # add link to resource
    link = resource.links.create
    link.target = 'http://example.com/resource/aee5acf5-71de-40b0-bd1c-2284658bfd0e'

    # render collection to text/plain MIME type
    rendered_collection = collection.to_json
    # parse rendered collection and compare with original collection
    Occi::Parser.parse('application/occi+json',rendered_collection).should == collection
  end

  it "should parse an OVF file" do
    media_type        = 'application/ovf+xml'
    body              = File.read('spec/occi/test.ovf')
    collection     = Occi::Parser.parse(media_type, body)
    storage_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#storage' }
    storage_resources.should have(1).storage_resource
    storage_resources.first.title.should == 'lamp'
    network_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#network' }
    network_resources.should have(1).network_resource
    network_resources.first.title.should == 'VM Network'
    compute_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#compute' }
    compute_resources.should have(1).compute_resource
    compute_resources.first.attributes.occi!.compute!.cores.should == 1
    compute_resources.first.attributes.occi!.compute!.memory.should == 0.25
  end

  it "should parse an OVA container" do
    media_type            = 'application/ova'
    body                  = File.read('spec/occi/test.ova')
    collection = Occi::Parser.parse(media_type, body)
    storage_resources     = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#storage' }
    storage_resources.should have(1).storage_resource
    storage_resources.first.title.should == 'lamp'
    network_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#network' }
    network_resources.should have(1).network_resource
    network_resources.first.title.should == 'VM Network'
    compute_resources = collection.resources.select { |resource| resource.kind.to_s == 'http://schemas.ogf.org/occi/infrastructure#compute' }
    compute_resources.should have(1).compute_resource
    compute_resources.first.attributes.occi!.compute!.cores.should == 1
    compute_resources.first.attributes.occi!.compute!.memory.should == 0.25
  end

end
