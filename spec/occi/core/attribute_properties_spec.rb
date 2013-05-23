require 'rspec'
require 'occi'

module Occi
  module Core
    describe AttributeProperties do

      describe '#[]=' do

        it 'sets the attribute property for a given attribute name using an Occi::Core::Attribute object' do
          attribute_properties=Occi::Core::AttributeProperties.new
          attribute_property = Occi::Core::AttributeProperty.new
          attribute_properties['test.test'] = attribute_property
          attribute_properties['test'].should be_kind_of Occi::Core::AttributeProperties
          attribute_properties['test']['test'].should == attribute_property
        end

      end

      describe '#[]' do

        it 'returns the attribute property for a given attribute name' do
          attribute_properties = Occi::Core::AttributeProperties.new
          attribute_properties['test'] =  Occi::Core::AttributeProperties.new
          attribute_properties['test']['test'] = Occi::Core::AttributeProperty.new
          attribute_properties['test.test'].should == attribute_properties['test']['test']
        end

      end
    end
  end
end