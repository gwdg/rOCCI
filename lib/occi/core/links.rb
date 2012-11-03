module Occi
  module Core
    class Links < Occi::Core::Entities

      def create(*args)
        link       = Occi::Core::Link.new(*args)
        link.model = @model
        self << link
      end

    end
  end
end
