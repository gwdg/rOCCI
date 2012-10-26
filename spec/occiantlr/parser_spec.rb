require 'rspec'
require 'hashie'

require 'occiantlr/OCCIANTLRParser'

module OCCIANTLR
    describe Parser do
      describe "#Category" do
        it "is parsed successful" do
          ATTRIBUTE                       = { :mutable => true, :required => false, :type => "string" }
          term                            = 'entity'
          scheme                          = 'http://schemas.ogf.org/occi/core#'
          class_type                      = 'kind'
          title                           = 'Storage Resource How\'s your quotes escaping?\"'
          rel                             = ['http://schemas.ogf.org/occi/core#resource#']
          location                        = '/storage/'
          attributes                      = Hashie::Mash.new
          attributes.occi!.storage!.size  = { :mutable => false, :required => false, :type => "string" }
          attributes.occi!.storage!.state = ATTRIBUTE
          attributes_string               = 'occi.storage.size{immutable} occi.storage.state'
          actions                         = Array.new
          actions << 'http://schemas.ogf.org/occi/infrastructure/storage/action#resize'
          actions << 'http://schemas.ogf.org/occi/infrastructure/storage/action#online'

          category_string = %Q{Category: #{term}; scheme="#{scheme}"; class="#{class_type}"; title="#{title}"; rel="#{rel.first}"; location="#{location}"; attributes="#{attributes_string}"; actions="#{actions.join(' ')}"}

          category = OCCIANTLR::Parser.new(category_string).category
          kind     = category[:kinds].first
          kind[:term].should == term
          kind[:scheme].should == scheme
          kind[:title].should == title
          kind[:related].should == rel
          kind[:location].should == location
          kind[:attributes].should == attributes
          kind[:actions].should == actions
        end
      end

      describe "#Link" do
        it "is parsed successful" do
          target                                       = '/network/123'
          rel                                          = 'http://schemas.ogf.org/occi/infrastructure#network'
          self_location                                = '/link/networkinterface/456'
          kind                                         = 'http://schemas.ogf.org/occi/infrastructure#networkinterface'
          attributes                                   = Hashie::Mash.new
          attributes.occi!.networkinterface!.interface = 'eth0'
          attributes.occi!.networkinterface!.mac       = '00:11:22:33:44:55'
          attributes.occi!.networkinterface!.state     = 'active'
          attributes_string                            = %Q{occi.networkinterface.interface="eth0";occi.networkinterface.mac="00:11:22:33:44:55";occi.networkinterface.state="active"}
          link_string                                  = %Q{Link: <#{target}>; rel="#{rel}"; self="#{self_location}"; category="#{kind}"; #{attributes_string}}

          link = OCCIANTLR::Parser.new(link_string).link
          link[:target].should == target
          link[:rel].should == rel
          link[:self].should == self_location
          link[:categories].first.should == kind
          link[:attributes].should == attributes
        end
      end

      describe "#X-OCCI-Attribute" do
        it "is parsed successful" do
          attribute                             = Hashie::Mash.new
          attribute.occi!.compute!.architecture = 'x86_64'

          x_occi_attributes_string = %Q{X-OCCI-Attribute: occi.compute.architecture="x86_64"}

          x_occi_attribute = OCCIANTLR::Parser.new(x_occi_attributes_string).x_occi_attribute
          x_occi_attribute.should == attribute
        end
      end

      describe "#X-OCCI-Location" do
        it "is parsed successful" do
          location        = URI.parse('http://example.com/compute/123')
          location_string = %Q{X-OCCI-Location: #{location.to_s}}
          x_occi_location = OCCIANTLR::Parser.new(location_string).x_occi_location
          x_occi_location.should == location
        end
      end
    end
  end
