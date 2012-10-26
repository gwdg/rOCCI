module Occi
  module Infrastructure
    module Os_tpl

      extend Occi

      def self.mixins
        mixin = Occi::Core::Mixin.new('http://schemas.ogf.org/occi/infrastructure#', 'os_tpl')

        mixin.title = "operating system template"

        mixin.related << Occi::Infrastructure::Compute.type_identifier

        mixin.location = '/mixins/os_tpl/'

        [mixin]
      end
    end
  end
end