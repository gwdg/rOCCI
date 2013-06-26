module Occi
  module Infrastructure
    module Os_tpl

      mattr_accessor :attributes, :mixin

      self.attributes = Occi::Core::AttributeProperties.new

      self.mixin = Occi::Core::Mixin.new scheme='http://schemas.ogf.org/occi/infrastructure#',
                                         term='os_tpl',
                                         title='operating system template',
                                         attributes=self.attributes,
                                         related=Occi::Core::Categories.new << Occi::Infrastructure::Compute.kind,
                                         actions=Occi::Core::Actions.new,
                                         location='/mixins/os_tpl/'
    end

  end
end