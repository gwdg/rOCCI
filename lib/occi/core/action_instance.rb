module Occi
  module Core
    class Action_instance

      class << self
        attr_accessor :actions
      end

      attr_accessor :action, :attributes, :model

      @action = Occi::Core::Action.new('http://schemas.ogf.org/occi/core#', 'action_instance')

      def initialize(action = self.action, attributes=self.action.attributes)
        if action.kind_of? String
          scheme, term = action.split '#'
          action = Occi::Core::Action.new(scheme, term)
        end
        @action     = action
        @attributes = Occi::Core::Attributes.new attributes
      end

    end
  end
end