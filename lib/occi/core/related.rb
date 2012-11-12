module Occi
  module Core
    class Related < Occi::Core::Categories

      private

      def convert(category)
        if category.kind_of? String
          model_category=nil
          model_category = @model.get_by_id category if @model
          if model_category
            return model_category
          end
        end
        category
      end

    end
  end
end