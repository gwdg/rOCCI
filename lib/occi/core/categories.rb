module Occi
  module Core
    class Categories < Set

      def initialize(categories=[])
        categories.to_a.collect! do |category|
          convert category
        end
        super categories
      end

      def <<(category)
        convert category
        super category
      end

      private

      def convert(category)
        if category.kind_of? String
          scheme, term = category.split '#'
          klass        = Occi::Core::Category.get_class scheme, term
          category     = klass.categories.first
        end
        category
      end

    end
  end
end