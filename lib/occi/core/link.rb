require 'hashie/mash'
require 'occi/core/entity'
require 'occi/core/kind'

module OCCI
  module Core
    class Link < Entity

      attr_accessor :rel, :source, :target

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

      # @param [String] kind
      # @param [String] mixins
      # @param [Occi::Core::Attributes] attributes
      # @param [Array] actions
      # @param [String] rel
      # @param [String,OCCI::Core::Entity] target
      # @param [String,OCCI::Core::Entity] source
      def initialize(kind, mixins=[], attributes={ }, actions=[], rel=nil, target=nil, source=nil)
        super(kind,mixins,attributes,actions)
        @rel = rel if rel
        self.source = source if source
        self.target = target
      end

      # @return [String] target attribute of the link
      def target
        @target ||= self.attributes.occi.core.target if @attributes.occi.core if @attributes.occi
        @target
      end

      # set target attribute of link
      # @param [String] target
      def target=(resource)
        @target = resource
      end

      # @return [String] source attribute of the link
      def source
        @source ||= self.attributes.occi.core.source if @attributes.occi.core if @attributes.occi
        @source
      end

      # set source attribute of link
      # @param [String] source
      def source=(resource)
        @source = resource
      end

      # @param [OCCI::Model] model
      def check(model)
        raise "rel must be provided" unless @rel
        super(model)
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        link = super
        link.rel = @rel if @rel
        link.source = self.source.to_s if self.source.to_s
        link.target = self.target.to_s if self.target
        link
      end

      # @return [String] text representation of link reference
      def to_reference_text
        OCCI::Log.debug "Test"
        text = '<' + target + '>'
        text << ';rel=' + @rel.inspect
        text << ';self=' + self.location
        text << ';category=' + @kind
        @attributes.combine.each_pair { |name, value| text << name + '=' + value + ';' }
        text
      end

    end
  end
end