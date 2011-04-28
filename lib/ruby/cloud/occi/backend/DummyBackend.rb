module OCCI
  module Backend
    class DummyBackend
      
      def initialize()
        @computeObjects = []
        @networkObjects = []
        @storageObjects = []
      end     
      
      def create_compute_instance(computeObject)
        @computeObjects << computeObject
      end
      
      def delete_compute_instance(computeObject)
        @computeObjects.delete(computeObject)
      end
      
      def create_network_instance(networkObject)
        @networkObjects << networkObject
      end
      
      def delete_network_instance(networkObject)
        @networkObjects.delete(networkObject)
      end
      
      def create_storage_instance(storageObject)
        @storageObjects << storageObject
      end
      
      def delete_storage_instance(storageObject)
        @storageObjects.delete(storageObject)
      end
      
      def get_all_vnet_ids
        return []
      end
      
      def get_all_image_ids
        return []
      end
      
      def print_configuration()
      end
      
    end
  end  
end