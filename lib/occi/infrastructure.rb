require 'occi/infrastructure/compute'
require 'occi/infrastructure/storage'
require 'occi/infrastructure/storagelink'
require 'occi/infrastructure/network'
require 'occi/infrastructure/networkinterface'

module Occi
  module Infrastructure

    extend Occi

    def self.kinds
      Occi::Core::Kinds.new << Occi::Infrastructure::Compute.kind << Occi::Infrastructure::Storage.kind << Occi::Infrastructure::Network.kind << Occi::Infrastructure::Networkinterface.kind << Occi::Infrastructure::Storagelink.kind
    end

    def self.mixins
      Occi::Infrastructure::Compute.mixins + Occi::Infrastructure::Storage.mixins + Occi::Infrastructure::Network.mixins + Occi::Infrastructure::Networkinterface.mixins + Occi::Infrastructure::Storagelink.mixins
    end

    def self.actions
      Occi::Infrastructure::Compute.actions + Occi::Infrastructure::Storage.actions + Occi::Infrastructure::Network.actions + Occi::Infrastructure::Networkinterface.actions + Occi::Infrastructure::Storagelink.actions
    end

  end
end