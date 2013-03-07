require 'json'
require 'erb'

module Occi
  module Bin

    class ResourceOutputFactory

      @@allowed_formats = [:json, :plain].freeze
      @@allowed_resource_types = [:compute, :storage, :network, :os_tpl, :resource_tpl].freeze
      @@allowed_data_types = [:locations, :resources].freeze

      attr_reader :output_format

      def initialize(output_format = :plain)
        raise "Unsupported output format!" unless @@allowed_formats.include? output_format
        @output_format = output_format
      end

      def format(data, data_type, resource_type)
        raise "Data has to be in an array!" unless data.is_a? Array
        raise "Unsupported resource type! Got: #{resource_type.to_s}" unless @@allowed_resource_types.include? resource_type
        raise "Unsupported data type! Got: #{data_type.to_s}" unless @@allowed_data_types.include? data_type

        # validate incoming data
        if data_type == :resources
          data.each do |occi_collection|
            raise "I need the resources to be in a Collection!" unless occi_collection.respond_to? :as_json
          end
        end

        # construct method name from data type and output format
        method = (data_type.to_s + "_to_" + output_format.to_s).to_sym

        ResourceOutputFactory.send method, data, resource_type
      end

      def self.allowed_formats
        @@allowed_formats
      end

      def self.allowed_resource_types
        @@allowed_resource_types
      end

      def self.allowed_data_types
        @@allowed_data_types
      end

      def self.resources_to_json(occi_resources, resource_type)
        # generate JSON document from an array of JSON objects 
        JSON.generate occi_resources
      end

      def self.resources_to_plain(occi_resources, resource_type)
        # using ERB templates for known resource and mixin types
        file = File.expand_path("..", __FILE__) + '/templates/' + resource_type.to_s + ".erb"
        template = ERB.new File.new(file).read

        formatted_output = ""

        occi_resources.each do |occi_resource|
          json_resource = occi_resource.as_json
          formatted_output << template.result(binding) unless json_resource.nil? || json_resource.empty?
        end

        formatted_output
      end

      def self.locations_to_json(url_locations, resource_type)
        # give all locatios a common key and convert to JSON
        locations = { resource_type => [] }

        url_locations.each do |location|
          location = location.split("/").last if [:os_tpl, :resource_tpl].include? resource_type
          locations[resource_type] << location
        end

        locations.to_json
      end

      def self.locations_to_plain(url_locations, resource_type)
        # just an attempt to make the array more readable 
        output = "\n" + resource_type.to_s.capitalize + " locations:\n"

        url_locations.each do |location|
          location = location.split("/").last if [:os_tpl, :resource_tpl].include? resource_type
          output << "\t" << location << "\n"
        end

        output
      end

    end

  end
end
