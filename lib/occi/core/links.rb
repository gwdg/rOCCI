module Occi
  module Core
    class Links < Occi::Core::Entities

      def initialize(links=[])
        links.collect! {|link| convert link} if links
        super links
      end

      def <<(link)
        super convert link
      end

      def create(*args)
        link       = Occi::Core::Link.new(*args)
        link.model = @model
        self << link
        link
      end

      private

      def convert(link)
        if link.kind_of? String
          target      = link
          link        = Occi::Core::Link.new
          link.target = target
        end
        link
      end

    end
  end
end
