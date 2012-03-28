require 'rspec'
require 'logger'
require 'hashie'

require 'occi/rendering/http/Request'

module OCCI
  module Rendering
    module HTTP
      describe Request do
        it "parses headers successfully" do
          ATTRIBUTE = { :mutable => true, :required => false, :type => { :string => {} }, :default => '' }
          #To change this template use File | Settings | File Templates.
          header = Hash.new
          header['HTTP_CATEGORY'] = %Q{my_tag;
          scheme="http://example.com/tags#";
          class="mixin";
          title="My Tag How's your quote's escaping \\" ?";
          rel="http://schemas.ogf.org/occi/infrastructure#resource_tpl";
          attributes="com.example.tags.my_tag" }
          categories = Request.parse_header_categories(header)
          categories[:mixins].first.should  be_kind_of(Hashie::Mash)
          categories[:mixins].first.term.should == 'my_tag'
          categories[:mixins].first.scheme.should == 'http://example.com/tags#'
          categories[:mixins].first.title.should == %Q{My Tag How's your quote's escaping \\" ?}
          categories[:mixins].first.related == 'http://schemas.ogf.org/occi/infrastructure#resource_tpl'
          categories[:mixins].first.attributes.com.example.tags.my_tag == ATTRIBUTE
        end

        it "parses plain text successfully" do

        end

        it "parses json successfully" do

        end
      end
    end
  end
end