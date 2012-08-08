require 'active_support/json'
require 'occi/core/category'

module OCCI
  module Core
    class Mixin < OCCI::Core::Category

      attr_accessor :entities, :related, :actions

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [OCCI::Core::AttributeProperties] attributes
      # @param [Array] related
      # @param [Array] actions
      def initialize(scheme, term, title=nil, attributes=nil, related=nil, actions=nil)
        @entities = []
        @related  = related.to_a
        @actions  = actions.to_a
        super(scheme, term, title, attributes)
      end

      # @return [String] string containing location URI of mixin
      def location
        '/mixins/' + @term + '/'
      end

      # @param [Hash] options
      # @return [Hashie::Mash] json representation
      def as_json(options={ })
        mixin = Hashie::Mash.new
        mixin.related = @related if @related.any?
        mixin.actions = @actions if @actions.any?
        mixin.merge! super
        mixin
      end

      # @return [String] text representation
      def to_text
        text = super
        text << ';rel=' + @related.join(' ').inspect if @related.any?
        text << ';location=' + self.location.inspect
        text << ';attributes=' + @attributes.combine.join(' ').inspect if @attributes.any?
        text << ';actions=' + @actions.join(' ').inspect if @actions.any?
        text
      end

    end
  end
end
