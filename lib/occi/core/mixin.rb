module Occi
  module Core
    class Mixin < Occi::Core::Category

      attr_accessor :entities, :related, :actions, :location

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
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        mixin = Hashie::Mash.new
        mixin.related = @related.join(' ').split(' ') if @related.any?
        mixin.actions = @actions if @actions.any?
        mixin.location = @location if @location
        mixin.merge! super
        mixin
      end

      # @return [String] text representation
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
