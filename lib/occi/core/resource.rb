module Occi
  module Core
    class Resource < Entity

      attr_accessor :links

      # @return [Occi::Core::Kind] kind definition of Resource type
      def self.kind
        kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'resource')

        kind.related = %w{http://schemas.ogf.org/occi/core#entity}
        kind.title   = 'resource'

        kind.attributes.occi!.core!.summary = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        kind
      end

      # @param [String] kind
      # @param [Array] mixins
      # @param [Occi::Core::Attributes,Hash] attributes
      # @param [Array] links
      def initialize(kind, mixins=[], attributes={ }, actions=[], links=[])
        super(kind, mixins, attributes, actions)
        @links = links
        @links ||= []
      end

      # set id for resource and update the the source of all links
      # @param [UUIDTools::UUID] id
      def id=(id)
        super(id)
      end

      # @return [String] summary attribute of the resource
      def summary
        self.attributes.occi.core.summary if @attributes.occi.core if @attributes.occi
      end

      # set summary attribute of resource
      # @param [String] summary
      def summary=(summary)
        self.attributes.occi!.core!.summary = summary
      end

      def link(target, kind=Occi::Core::Link.kind, mixins=[], attributes=Occi::Core::Attributes.new, rel=Occi::Core::Resource.type_identifier)
        link            = kind.entity_type.new
        link.rel        = rel
        link.attributes = attributes
        link.target     = target
        link.source     = self
        link.mixins     = mixins
        @links << link
        link
      end

      # @param [Hash] options
      # @return [Hashie::Mash] link as Hashie::Mash to be parsed into a JSON object
      def as_json(options={ })
        resource = super
        resource.links = @links if @links.any?
        resource
      end

    end
  end
end
