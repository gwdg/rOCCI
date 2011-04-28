require 'occi/core/Mixin'
require 'singleton'

module OCCI
  module Infrastructure
    class Ipnet6 < OCCI::Core::Mixin

      # Define appropriate mixin
      begin
          # Define actions
          actions = []

          related = []
          entities = []

          term    = "ipnet6"
          scheme  = "http://schemas.ogf.org/occi/infrastructure/network#"
          title   = "Ipnet6 Mixin"

          attributes = OCCI::Core::Attributes.new()
          attributes << OCCI::Core::Attribute.new(name = 'occi.network.subnet', mutable = true, mandatory = true, unique = true)
          
          MIXIN = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
      end

      def initialize(term, scheme, title, attributes, actions, related, entities)
        super(term, scheme, title, attributes, actions, related, entities)
      end
    end
  end
end