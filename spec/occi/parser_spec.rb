require "rspec"
require 'occi/parser'

describe "Parser" do

  it "should parse OCCI message with entity in text plain format" do
    media_type = 'text/plain'
    body = %Q|Category: compute; scheme="http://schemas.ogf.org/occi/infrastructure#"; class="kind"\nX-OCCI-Attribute: occi.compute.cores=2|
    category = false
    OCCI::Parser.parse(media_type,body,category)
  end
end