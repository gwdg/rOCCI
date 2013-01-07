module Occi
  module Api
    module Dsl

      def connect(protocol, *args)

        case protocol
        when :http 
          @client = Occi::Api::Client::ClientHttp.new(*args)
        when :amqp
          @client = Occi::Api::Client::ClientAmqp.new(*args)
        else
          raise "Protocol #{protocol.to_s} is not supported!"
        end

        true
      end

      def list(*args)
        check

        @client.list(*args)
      end

      def describe(*args)
        check

        @client.describe(*args)
      end

      def create(*args)
        check

        @client.create(*args)
      end

      def delete(*args)
        check

        @client.delete(*args)
      end

      def trigger(*args)
        check

        @client.trigger(*args)
      end

      def refresh
        check

        @client.refresh
      end

      def model
        check

        @client.model
      end

      ###

      def resource_types
        check

        @client.get_resource_types
      end

      def resource_type_identifiers
        check

        @client.get_resource_type_identifiers
      end

      def mixin_type_identifiers
        check

        @client.get_mixin_type_identifiers
      end

      def mixin_types
        check

        @client.get_mixin_types
      end

      def entity_types
        check

        @client.get_entity_types
      end

      def entity_type_identifiers
        check

        @client.get_entity_type_identifiers
      end

      def entity_types_related_to(*args)
        check

        @client.get_entity_types_related_to(*args)
      end

      def link_types
        check

        @client.get_link_types
      end

      def link_type_identifiers
        check

        @client.get_link_type_identifiers
      end

      ###

      def mixins(*args)
        check

        @client.get_mixins(*args)
      end

      def resource(*args)
        check

        @client.get_resource(*args)
      end

      def mixin(*args)
        check

        @client.find_mixin(*args)
      end

      private

      def check
        raise "You have to issue 'connect' first!" if @client.nil?
        raise "Client is disconnected!" unless @client.connected
      end

    end
  end
end
