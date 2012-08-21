require 'hashie/mash'
require 'active_support/json'
require 'occi/core/entity'
require 'occi/core/kind'

module OCCI
  module Core
    class Resource < Entity

      attr_accessor :links

      # @return [OCCI::Core::Kind] kind definition of Resource type
      def self.kind_definition
        kind = OCCI::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'resource')

        kind.related = %w{http://schemas.ogf.org/occi/core#entity}
        kind.title   = 'Resource'

        kind.attributes.occi!.core!.summary!.Type     = 'string'
        kind.attributes.occi!.core!.summary!.Pattern  = '.*'
        kind.attributes.occi!.core!.summary!.Required = false
        kind.attributes.occi!.core!.summary!.Mutable  = true

        kind
      end

      # @param [String] kind
      # @param [Array] mixins
      # @param [OCCI::Core::Attributes,Hash] attributes
      # @param [Array] links
      def initialize(kind, mixins=nil, attributes=nil, links=nil)
        super(kind, mixins, attributes)
        @links = []
        links.to_a.each do |link|
          link = OCCI::Core::Link.new(link.kind,link.mixins,link.attributes,link.actions,link.rel) unless link.kind_of? OCCI::Core::Link
          @links << link
        end
      end

      # set id for resource and update the the source of all links
      # @param [UUIDTools::UUID] id
      def id=(id)
        super(id)
        @links.each { |link| link.attributes.occi!.core!.source = self.location }
      end

      # @return [String] summary attribute of the resource
      def summary
        self.attributes.occi!.core!.summary
      end

      # set summary attribute of resource
      # @param [String] summary
      def summary=(summary)
        self.attributes.occi!.core!.summary = summary
      end

      # @param [Hash] options
      # @return [Hashie::Mash] link as Hashie::Mash to be parsed into a JSON object
      def as_json(options={ })
        resource = Hashie::Mash.new
        resource.links = @links.collect { |link| link.as_json } if @links.any?
        resource.merge! super
        resource
      end

      # @return [String] text representation
      def to_text
        text = super
        @links.each { |link| text << 'Link: ' + link.to_reference_text + "\n" }
        text
      end

    end
  end
end
