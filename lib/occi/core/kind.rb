require 'json'
require 'occi/core/category'
require 'occi/core/action'
require 'occi/core/attribute_properties'

module OCCI
  module Core
    class Kind < OCCI::Core::Category

      attr_accessor :entities

      def initialize(kind, default = nil)
        @entities = []
        super(kind, default)
      end

      def entity_type
        case type_identifier
          when "http://schemas.ogf.org/occi/core#resource"
            return OCCI::Core::Resource.name
          when "http://schemas.ogf.org/occi/core#link"
            return OCCI::Core::Link.name
          else
            OCCI::Model.get_by_id(self[:related].first).entity_type unless self[:term] == 'entity'
        end
      end

      def location
        '/' + self[:term] + '/'
      end

    end
  end
end
