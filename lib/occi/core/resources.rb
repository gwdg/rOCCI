module Occi
  module Core
    class Resources < Occi::Core::Entities

      def create(*args)
        resource       = Occi::Core::Resource.new(*args)
        resource.model = @model
        self << resource
      end

    end
  end
end