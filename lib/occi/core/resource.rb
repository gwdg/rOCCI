require 'hashie/mash'
require 'active_support/json'
require 'occi/core/entity'
require 'occi/core/kind'

module OCCI
  module Core
    class Resource < Entity

      attr_accessor :links

      def initialize(kind, mixins=nil, attributes=nil, links=nil)
        @links = links.to_a
        super(kind, mixins, attributes)
      end

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

      def links=(links)
        @checked = false
        @links   = links
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

      # update the source of all links before returning them
      # @return [Array] links of resource
      def links
        @links.each { |link| link.attributes.occi!.core!.source = self.location }
        @links
      end

      def as_json(options={ })
        resource = Hashie::Mash.new
        resource.links = @links if @links.any?
        resource.merge! super
        resource
      end

    end
  end
end
