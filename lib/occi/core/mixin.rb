require 'json'
require 'occi/core/category'

module OCCI
  module Core
    class Mixin < OCCI::Core::Category

      attr_accessor :entities

      def initialize(mixin, default = nil)
        @entities = []
        super(mixin, default)
      end

      def location
        '/mixin/' + self[:term] + '/'
      end

    end
  end
end
