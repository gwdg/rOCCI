module Occi
  module Core
    class Mixins < Occi::Core::Categories

      private

      def convert(category)
        category = super category

        if category.kind_of? String
          scheme, term = category.split '#'
          scheme       += '#'

          klass    = Occi::Core::Category.get_class scheme, term, [Occi::Core::Mixin.new]
          category = klass.new(scheme, term)
        end
        category
      end

    end
  end
end