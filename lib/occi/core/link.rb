module Occi
  module Core
    class Link < Entity

      attr_accessor :rel, :source, :target

      # @return [Occi::Core::Kind] kind definition of Link type
      def self.kind
        kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'link')

        kind.related = %w{http://schemas.ogf.org/occi/core#entity}
        kind.title   = "link"

        kind.attributes.occi!.core!.target = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        kind.attributes.occi!.core!.source = Occi::Core::AttributeProperties.new(
            { :mutable => true })

        kind
      end

      # @param [String] kind
      # @param [String] mixins
      # @param [Occi::Core::Attributes] attributes
      def initialize(kind, mixins=[], attributes={ }, actions=[], rel=nil, target=nil, source=nil)
        super(kind, mixins, attributes, actions)
        @rel = rel if rel
        self.id = UUIDTools::UUID.random_create.to_uri unless self.id
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

      # @param [Occi::Model] model
      def check(model)
        raise "rel must be provided" unless @rel
        super(model)
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        link = super
        link.rel = @rel if @rel
        link.source = self.source.to_s if self.source.kind_of? String if self.source
        link.target = self.target.to_s if self.target
        link
      end

      # @return [String] text representation of link reference
      def to_string
        string = '<' + self.target.to_s + '>'
        string << ';rel=' + @rel.inspect
        string << ';self=' + self.location.inspect
        categories = [@kind] + @mixins
        string << ';category=' + categories.join(' ').inspect
        string << ';' if @attributes.any?
        @attributes.combine.each_pair do |name, value|
          value = value.inspect
          string << name + '=' + value + ';'
        end
        puts self.target.to_s
        string << 'occi.core.id=' + self.id.inspect
        string << 'occi.core.target=' + self.target.to_s.inspect
        string << 'occi.core.source=' + self.source.to_s.inspect if self.source.kind_of? String if self.source

        string
      end

      def to_text_link
        'Link: ' + self.to_string
      end

    end
  end
end