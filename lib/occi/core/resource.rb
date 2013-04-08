module Occi
  module Core
    class Resource < Occi::Core::Entity

      attr_accessor :links

      @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'resource')

      @kind.related << Occi::Core::Entity.kind
      @kind.title   = 'resource'

      @kind.attributes.occi!.core!.summary = Occi::Core::AttributeProperties.new(
          { :mutable => true })

      # @param [String] kind
      # @param [Array] mixins
      # @param [Occi::Core::Attributes,Hash] attributes
      # @param [Array] links
      # @return [Occi::Core::Resource]
      def initialize(kind=self.kind, mixins=[], attributes={ }, actions=[], links=[])
        super(kind, mixins, attributes, actions)
        @links = Occi::Core::Links.new(links)
      end

      def model=(model)
        super model
        @links.model = model
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

      # @return [String] text representation
      def to_text
        text = super
        @links.each { |link| text << link.to_text_link + "\n" }
        text
      end

      # @return [Hash] hash containing the HTTP headers of the text/occi rendering
      def to_header
        header = super
        header['Link'] = @links.join(',') if @links.any?

        header
      end

      # @param [Hash] options
      # @return [Hashie::Mash] link as Hashie::Mash to be parsed into a JSON object
      def as_json(options={ })
        resource     = super
        link_strings = @links.collect { |link| link.to_s if link.to_s }.compact
        resource.links = link_strings unless link_strings.empty?
        resource
      end

    end
  end
end
