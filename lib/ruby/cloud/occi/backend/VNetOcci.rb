module OCCI
  module Backend
    class VNetOcci < OpenNebula::VirtualNetwork
      def initialize(xml, node, *args)
        super(xml,node)
      end

      # Retrieves the information of the given VirtualMachine.
      def info()
        begin
          super()
        rescue Exception => e
          error = OpenNebula::Error.new(e.message)
          return error
        end
        return @xml
      end

      # TODO: this method is to be implement although for the rest of suptype of OpenNebula API Classes, e.g. VNetOcci <  OpenNebula::VirtualNetwork
      def info_xml()
        rc = info()
        return @xml
      end

      # Transform informations of a VM(Object) in to a Human-readable form on selected Field
      # relating to the template object "occivm"
      def to_occi(occivm)
        begin
          occi_vm = ERB.new(occivm)
          occi_vm_text = occi_vm.result(binding)
        rescue Exception => e
          error = OpenNebula::Error.new(e.message)
          return error
        end

        return occi_vm_text.gsub(/\n\s*/,'')
      end

    end
  end
end