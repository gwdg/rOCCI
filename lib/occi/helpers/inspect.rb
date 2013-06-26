module Occi
  module Helpers
    module Inspect

      # @return [String] json representation
      def inspect
        JSON.pretty_generate(JSON.parse(to_json))
      end

    end
  end
end