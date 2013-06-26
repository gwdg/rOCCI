module Occi
  module Core
    class Kind < Occi::Core::Category

      attr_accessor :entities, :parent, :actions, :location

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [Hash] attributes
      # @param [Array] related
      # @param [Array] actions
      def initialize(scheme='http://schemas.ogf.org/occi/core#',
          term='kind',
          title=nil,
          attributes=Occi::Core::AttributeProperties.new,
          related=Occi::Core::Related.new,
          actions=Occi::Core::Actions.new,
          location=nil)
        super(scheme, term, title, attributes)
        @related = Occi::Core::Related.new(related)
        @actions = Occi::Core::Actions.new(actions)
        @entities = Occi::Core::Entities.new
        location.blank? ? @location = '/' + term + '/' : @location = location
      end

      def entity_type
        self.class.get_class @scheme, @term, @related
      end

      def location
        @location.clone
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={})
        kind = Hashie::Mash.new
        kind.related = @related.join(' ').split(' ') if @related.any?
        kind.actions = @actions.join(' ').split(' ') if @actions.any?
        kind.location = @location if @location
        kind.merge! super
        kind
      end

      # @return [String] string representation of the kind
      def to_string
        string = super
        string << ';rel=' + @related.join(' ').inspect if @related.any?
        string << ';location=' + self.location.inspect
        string << ';attributes=' + @attributes.combine.keys.join(' ').inspect if @attributes.any?
        string << ';actions=' + @actions.join(' ').inspect if @actions.any?
        string
      end

    end
  end
end
