module Occi
  module Core
    class Actions < Occi::Core::Categories

      private

      def convert(category)
        category = super category

        if category.kind_of? String
          scheme, term = category.split '#'
          scheme       += '#'
          category = Occi::Core::Action.new(scheme, term)
        end
        category
      end

    end
  end
end