require 'occi/infrastructure/compute'
require 'occi/infrastructure/storage'
require 'occi/infrastructure/storagelink'
require 'occi/infrastructure/network'
require 'occi/infrastructure/networkinterface'
require 'occi/infrastructure/os_tpl'
require 'occi/infrastructure/resource_tpl'

module Occi
  module Infrastructure

    extend Occi

    def self.kinds
      kinds = []
      kinds << Occi::Infrastructure::Compute.kind
      kinds << Occi::Infrastructure::Storage.kind
      kinds << Occi::Infrastructure::Network.kind
      kinds << Occi::Infrastructure::Networkinterface.kind
      kinds << Occi::Infrastructure::Storagelink.kind
      kinds.compact.reject { |entry| entry == [] }
    end

    def self.mixins
      mixins = []
      mixins.concat Occi::Infrastructure::Os_tpl.mixins
      mixins.concat Occi::Infrastructure::Resource_tpl.mixins
      mixins.concat Occi::Infrastructure::Network.mixins
      mixins.concat Occi::Infrastructure::Networkinterface.mixins
      mixins.compact.reject { |entry| entry == [] }
    end

    def self.actions
      actions = []
      actions.concat Occi::Infrastructure::Compute.actions
      actions.concat Occi::Infrastructure::Storage.actions
      actions.concat Occi::Infrastructure::Network.actions
      actions.compact.reject { |entry| entry == [] }
    end

  end
end