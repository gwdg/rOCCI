require "rspec"

module Occi
  module Core
    describe Entity do

      it "initializes itself successfully" do
        entity = Occi::Core::Entity.new
        entity.should be_kind_of Occi::Core::Entity
        puts entity.kind == Occi::Core::Entity.kind
      end

      it "initializes a subclass successfully" do
        type_identifier = 'http://example.com/testnamespace#test'
        entity = Occi::Core::Entity.new type_identifier
        entity.should be_kind_of 'Com::Example::Testnamespace::Test'.constantize
        entity.kind.type_identifier.should == type_identifier
        entity.kind.related.first.should == Occi::Core::Entity.kind
      end

    end
  end
end