require 'hashie/mash'

module OCCI
  module Core
    class Attributes < Hashie::Mash

      def combine
        hash = {}
        self.each_key do |key|
          if self[key].kind_of? Hashie::Mash
            self[key].combine.each_pair { |k, v| hash[key + '.' + k] = v }
          else
            hash[key] = self[key]
          end
        end
        return hash
      end

    end
  end
end