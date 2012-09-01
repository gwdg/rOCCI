require 'rubygems'

module OCCI
	module DSL

		def connect(*args)
			@client = OCCI::Client.new(*args)

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

		def storagelink(*args)
			check

			@client.storagelink(*args)
		end

		def networkinterface(*args)
			check

			@client.networkinterface(*args)
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

		def mixin_tyoes
			check

			@client.get_mixin_types
		end

		def mixins(*args)
			check

			@client.get_mixins(*args)
		end

		###

		def instance(*args)
			check

			@client.get_instance(*args)
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