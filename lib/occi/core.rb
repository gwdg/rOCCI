require 'occi/core/category'
require 'occi/core/kind'
require 'occi/core/mixin'
require 'occi/core/action'
require 'occi/core/entity'
require 'occi/core/link'
require 'occi/core/resource'
require 'occi/core/attribute'
require 'occi/core/attributes'

module OCCI
  module Core
    # @return [Array] list of OCCI::Core::Categories
    def self.categories
      categories = []
      categories << OCCI::Core::Entity.kind
      categories << OCCI::Core::Link.kind
      categories << OCCI::Core::Resource.kind
    end
  end
end