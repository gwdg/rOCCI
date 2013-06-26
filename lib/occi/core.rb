require 'occi/core/attribute_property'
require 'occi/core/attribute_properties'
require 'occi/core/attribute'
require 'occi/core/attributes'
require 'occi/core/category'
require 'occi/core/categories'
require 'occi/core/related'
require 'occi/core/kind'
require 'occi/core/kinds'
require 'occi/core/mixin'
require 'occi/core/mixins'
require 'occi/core/action'
require 'occi/core/action_instance'
require 'occi/core/actions'
require 'occi/core/entities'
require 'occi/core/entity'
require 'occi/core/link'
require 'occi/core/links'
require 'occi/core/resource'
require 'occi/core/resources'

module Occi
  module Core

    extend Occi

    def self.kinds
      Occi::Core::Kinds.new << Occi::Core::Entity.kind << Occi::Core::Link.kind << Occi::Core::Resource.kind
    end

  end
end