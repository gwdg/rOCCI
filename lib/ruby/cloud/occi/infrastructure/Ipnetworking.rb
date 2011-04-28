require 'occi/core/Mixin'
require 'singleton'


module OCCI
  module Infrastructure
    class Ipnetworking < OCCI::Core::Mixin

      # Define appropriate mixin
      begin
        # Define actions
        actions = []

        related = []
        entities = []

        term    = "ipnetwork"
        scheme  = "http://schemas.ogf.org/occi/infrastructure/network#"
        title   = "IP Network Mixin"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.address', mutable = true, mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.gateway', mutable = true, mandatory = false, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.network.allocation', mutable = true, mandatory = true, unique = true)
          
        MIXIN = OCCI::Core::Mixin.new(term, scheme, title, attributes, actions, related, entities)
      end

      def initialize(term, scheme, title, attributes, actions, related, entities)
        super(term, scheme, title, attributes, actions, related, entities)
      end

    end
  end
end