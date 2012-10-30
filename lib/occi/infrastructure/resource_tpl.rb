module Occi
  module Infrastructure
    module Resource_tpl

      extend Occi

      def self.mixins
        [self.mixin]
      end

      def self.mixin
        mixin = Occi::Core::Mixin.new('http://schemas.ogf.org/occi/infrastructure#', 'resource_tpl')

        mixin.title = "resource template"

        mixin.related << Occi::Infrastructure::Compute.type_identifier

        mixin.location = '/mixins/resource_tpl/'

        mixin
      end
    end
  end
end