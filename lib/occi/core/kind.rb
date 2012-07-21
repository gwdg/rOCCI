require 'active_support/json'
require 'occi/core/category'
require 'occi/core/action'
require 'occi/core/attribute_properties'

module OCCI
  module Core
    class Kind < OCCI::Core::Category

      attr_accessor :entities, :related, :actions

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [OCCI::Core::AttributeProperties] attributes
      # @param [Array] related
      # @param [Array] actions
      def initialize(scheme, term, title=nil, attributes=nil, related=nil, actions=nil)
        @entities = []
        @related  = related.to_a
        @actions  = actions.to_a
        super(scheme, term, title, attributes)
      end

      # @return [String] name of the OCCI core class the entity is related to
      def entity_type
        case type_identifier
          when "http://schemas.ogf.org/occi/core#resource"
            return OCCI::Core::Resource.name
          when "http://schemas.ogf.org/occi/core#link"
            return OCCI::Core::Link.name
          else
            raise "no model back reference provided for kind #{self.typ_identifier}" unless @model
            @model.get_by_id(self[:related].first).entity_type unless self[:term] == 'entity'
        end
      end

      # @return [String] string containing location URI of kind
      def location
        '/' + @term + '/'
      end

      def as_json(options={ })
        kind = Hashie::Mash.new
        kind.related = @related if @related.any?
        kind.actions = @actions if @actions.any?
        kind.merge! super
        kind
      end

      def to_text
        text = super
        text << ';rel=' + @related.join(' ').inspect if @related.any?
        text << ';location=' + self.location.inspect
        text << ';attributes=' + @attributes.combine.join(' ').inspect if @attributes.any?
        text << ';actions=' + @actions.join(' ').inspect if @actions.any?
        text
      end

    end
  end
end
