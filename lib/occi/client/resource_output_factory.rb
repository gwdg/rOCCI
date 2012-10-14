require 'active_support/all'

class ResourceOutputFactory

	def self.json_to_yaml(json_encoded_resource)
		json_encoded_resource = ActiveSupport::JSON.decode(json_encoded_resource) if json_encoded_resource.is_a? String
		json_encoded_resource.to_yaml
	end

	def self.json_to_xml(json_encoded_resource)    
		# TODO: use classes from Occi Core to generate XML 
        json_encoded_resource = ActiveSupport::JSON.decode(json_encoded_resource) if json_encoded_resource.is_a? String
		json_encoded_resource.to_xml
    end

    def self.json_to_plain_pretty(json_encoded_resource)
    	# TODO: use ERB templates for known resource and mixin types
    	json_encoded_resource
    end

end