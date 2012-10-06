module Occi
  module Core
    class Kind < Occi::Core::Category

      attr_accessor :entities, :related, :actions, :location, :entity_type

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [Hash] attributes
      # @param [Array] related
      # @param [Array] actions
      def initialize(scheme, term, title=nil, attributes={}, related=[], actions=[],location=nil)
        super(scheme, term, title, attributes)
        @related  = related.to_a.flatten
        @actions  = actions.to_a.flatten
        @location = location ||= '/' + term + '/'
        @entities = []
        @entity_type = self.class.get_class scheme, term, related
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        kind = Hashie::Mash.new
        kind.related = @related if @related.any?
        kind.actions = @actions if @actions.any?
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
