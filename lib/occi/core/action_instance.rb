module Occi
  module Core
    class Action_instance

      attr_accessor :action, :attributes, :model

      def initialize(action, attributes={ })
        @action     = action
        @attributes = attributes
      end

    end
  end
end