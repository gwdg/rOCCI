module Occi
  module Core
    class Mixin < Occi::Core::Category

      attr_accessor :entities, :related, :actions, :location

      # @param [String ] scheme
      # @param [String] term
      # @param [String] title
      # @param [Occi::Core::Attributes,Hash,NilClass] attributes
      # @param [Occi::Core::Categories,Hash,NilClass] related
      # @param [Occi::Core::Actions,Hash,NilClass] actions
      def initialize(scheme='http://schemas.ogf.org/occi/core#',
          term='mixin',
          title=nil,
          attributes=Occi::Core::AttributeProperties.new,
          related=Occi::Core::Related.new,
          actions=Occi::Core::Actions.new,
          location='')

        super(scheme, term, title, attributes)
        @related  = Occi::Core::Related.new(related)
        @actions  = Occi::Core::Actions.new(actions)
        @entities = Occi::Core::Entities.new
        location.blank? ? @location = '/mixins/' + term + '/' : @location = location
      end

      def location
        @location.clone
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
