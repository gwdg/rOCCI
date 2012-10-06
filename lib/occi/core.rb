require 'occi/core/category'
require 'occi/core/kind'
require 'occi/core/mixin'
require 'occi/core/action'
require 'occi/core/entity'
require 'occi/core/link'
require 'occi/core/resource'
require 'occi/core/attributes'
require 'occi/core/attribute_properties'

module Occi
  module Core

    extend Occi

    def self.kinds
      [
          Occi::Core::Entity.kind,
          Occi::Core::Link.kind,
          Occi::Core::Resource.kind
      ]
    end

  end
end