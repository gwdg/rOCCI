module Occi
  module Core
    class Link < Occi::Core::Entity

      attr_accessor :rel, :source, :target

      @kind = Occi::Core::Kind.new('http://schemas.ogf.org/occi/core#', 'link')

      @kind.related << Occi::Core::Entity.kind
      @kind.title = "link"

      @kind.attributes.occi!.core!.target = Occi::Core::AttributeProperties.new(
          { :mutable => true })

      @kind.attributes.occi!.core!.source = Occi::Core::AttributeProperties.new(
          { :mutable => true })

      # @param [String] kind
      # @param [String] mixins
      # @param [Occi::Core::Attributes] attributes
      # @param [Array] actions
      # @param [String] rel
      # @param [String,Occi::Core::Entity] target
      # @param [String,Occi::Core::Entity] source
      def initialize(kind=self.kind, mixins=[], attributes={ }, actions=[], rel=nil, target=nil, source=nil)
        super(kind, mixins, attributes, actions)
        if rel.kind_of? String
          scheme, term = rel.to_s.split('#')
          @rel         = Occi::Core::Category.get_class(scheme, term).kind if scheme && term
        end
        @source = source if source
        @target = target
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
        link.rel = @rel.to_s if @rel
        link.source = self.source.to_s if self.source.to_s
        link.target = self.target.to_s if self.target
        link
      end

      # @return [String] text representation of link reference
      def to_string
        string = '<' + self.target.to_s + '>'
        string << ';rel=' + @rel.to_s.inspect
        string << ';self=' + self.location.inspect if self.location
        categories = [@kind] + @mixins.join(',').split(',')
        string << ';category=' + categories.join(' ').inspect
        string << ';'
        @attributes.combine.each_pair do |name, value|
          value = value.inspect
          string << name + '=' + value + ';'
        end
        string << 'occi.core.target=' + self.target.to_s.inspect
        string << 'occi.core.source=' + self.source.to_s.inspect if self.source.to_s

        string
      end

      # @return [String] text representation of link
      def to_text_link
        'Link: ' + self.to_string
      end

    end
  end
end