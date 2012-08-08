require 'hashie/mash'

module OCCI
  module Core
    class Attributes < Hashie::Mash

    # @return [Array] key value pair of full attribute names with their corresponding values
    def combine
        hash = { }
        self.each_key do |key|
          if self[key].kind_of? OCCI::Core::Attributes
            self[key].combine.each_pair { |k, v| hash[key + '.' + k] = v }
          else
            hash[key] = self[key]
          end
        end
        hash
      end

    # @param [Hash] attributes key value pair of full attribute names with their corresponding values
    # @return [OCCI::Core::Attributes]
    def self.split(attributes)
        attribute = Attributes.new
        attributes.each do |name,value|
          puts name
          key, _, rest = name.partition('.')
          if rest.empty?
            attribute[key] = value
          else
            attribute.merge! Attributes.new(key => self.split(rest => value))
          end
        end
        return attribute
      end

    end
  end
end