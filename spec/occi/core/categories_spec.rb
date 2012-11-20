require 'rspec'
require 'occi'

module Occi
  module Core
    describe Categories do

      it "replaces an existing category instance when a model is added with the instance from the model"  do
        categories = Occi::Core::Categories.new
        categories << Occi::Core::Resource.kind
        model = Occi::Model.new
        resource = model.get_by_id Occi::Core::Resource.type_identifier
        resource.location = '/new_location/'
        categories.model = model
        categories.first.location.should == '/new_location/'
      end

      it "replaces a category string when a model is added with the instance from the model"  do
        categories = Occi::Core::Categories.new
        categories << Occi::Core::Resource.type_identifier
        model = Occi::Model.new
        resource = model.get_by_id Occi::Core::Resource.type_identifier
        resource.location = '/new_location/'
        categories.model = model
        categories.first.location.should == '/new_location/'
      end

    end
  end
end
