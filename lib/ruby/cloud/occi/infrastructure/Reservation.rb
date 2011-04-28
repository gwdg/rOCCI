require 'occi/core/Mixin'
require 'singleton'

module OCCI
  module Infrastructure
    class Reservation < OCCI::Core::Mixin
      include Singleton
      @@reservation = nil
      def initialize()
        #@entity = entity
        term, scheme, title, attributes, actions, related, entities =  self.getMixin()
        #@entities = self.add_entity()
        super(term, scheme, title, attributes, actions, related, entities)
      end

      def getMixin()
        actions = []
        related = []
        entities = []

        term = "reservation"
        scheme = "http://schemas.ogf.org/occi/infrastructure/compute#"
        title = "Reservation"

        attributes = OCCI::Core::Attributes.new()
        attributes << OCCI::Core::Attribute.new(name = 'occi.reservation.start', mutable = false, mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.reservation.leastype', mutable = false, mandatory = false, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.reservation.duration', mutable = false, mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.reservation.preemptible', mutable = false, mandatory = true, unique = true)
        attributes << OCCI::Core::Attribute.new(name = 'occi.reservation.strategy', mutable = false, mandatory = false, unique = true)
        return term, scheme, title, attributes, actions, related, entities
      end

      def self.get_scheme()
        scheme = %Q{"http://schemas.ogf.org/occi/infrastructure/compute#"}
        return scheme
      end

      def self.get_term()
        term = "reservation"
        return term
      end

      def self.title()
        title = "Reservation"
        return title
      end
    end
  end
end