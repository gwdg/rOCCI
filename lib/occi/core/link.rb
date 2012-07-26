require 'hashie/mash'
require 'occi/core/entity'
require 'occi/core/kind'

module OCCI
  module Core
    class Link < Entity

      attr_reader :rel

      # @return [OCCI::Core::Kind] kind definition of Link type
      def self.kind_definition
        kind = OCCI::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'link')

        kind.related = %w{http://schemas.ogf.org/occi/core#entity}
        kind.title   = "Link"

        kind.attributes.occi!.core!.target!.Type     = "string"
        kind.attributes.occi!.core!.target!.Pattern  = ".*"
        kind.attributes.occi!.core!.target!.Required = false
        kind.attributes.occi!.core!.target!.Mutable  = true

        kind.attributes.occi!.core!.source!.Type     = "string"
        kind.attributes.occi!.core!.source!.Pattern  = ".*"
        kind.attributes.occi!.core!.source!.Required = false
        kind.attributes.occi!.core!.source!.Mutable  = true

        kind
      end

      # @return [String] target attribute of the link
      def target
        self.attributes.occi!.core!.summary
      end

      # set target attribute of link
      # @param [String] target
      def target=(target)
        self.attributes.occi!.core!.target = target
      end

      # @return [String] source attribute of the link
      def source
        self.attributes.occi!.core!.source
      end

      # set source attribute of link
      # @param [String] source
      def source=(source)
        self.attributes.occi!.core!.source = source
      end

      def check(model)
        target = model.get_by_id(self.target)
        @rel = model.type_identifier if target.kind_of? OCCI::Core::Resource
        super(model)
      end

      # @param [Hash] options
      # @return [Hashie::Mash] link as Hashie::Mash to be parsed into a JSON object
      def as_json(options={ })
        link = Hashie::Mash.new
        link.kind = @kind if @kind
        link.rel = @rel if @rel
        link.mixins = @mixins if @mixins.any?
        link.attributes = @attributes if @attributes.any?
        link
      end

    end
  end
end