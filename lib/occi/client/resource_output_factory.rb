require 'json'
require 'erb'

class ResourceOutputFactory

  @@allowed_formats = [:json, :plain].freeze
  @@allowed_resource_types = [:compute, :storage, :network, :os_tpl, :resource_tpl].freeze
  attr_accessor :output_format

  def initialize(output_format = :plain)
    raise "Unsupported output format!" unless @@allowed_formats.include? output_format
    @output_format = output_format
  end

  def format(data, data_type, resource_type)
    raise "I need an array to format the output properly!" unless data.is_a? Array
    raise "Unsupported resource type!" unless @@allowed_resource_types.include? resource_type

    case data_type
    when :resources
      # validate incoming data
      begin
        data = JSON.parse(data) if data.is_a? String
        JSON.generate(data)
      rescue
        # report errors
        raise "I need the resources to be in a JSON-formatted string or a JSON object!"
      end

      method = ("resources_to_" + output_format.to_s).to_sym
    when :locations
      method = ("locations_to_" + output_format.to_s).to_sym
    else
      raise "Unknown data type!"
    end

    ResourceOutputFactory.send method, data, resource_type
  end

  def self.allowed_formats
    @@allowed_formats
  end

  def self.allowed_resource_types
    @@allowed_resource_types
  end

  def self.resources_to_json(json_encoded_resources, resource_type)
    # generate JSON document from an array of JSON objects 
    JSON.generate json_encoded_resources
  end

  def self.resources_to_plain(json_encoded_resources, resource_type)
    # using ERB templates for known resource and mixin types
    file = File.expand_path("..", __FILE__) + '/templates/' + resource_type.to_s + ".erb"
    template = ERB.new File.new(file).read

    template.result(binding)
  end

  def self.locations_to_json(url_locations, resource_type)
    # give all locatios a common key and convert to JSON
    { resource_type => url_locations }.to_json
  end

  def self.locations_to_plain(url_locations, resource_type)
    # just an attempt to make the array more readable 
    output = resource_type.to_s.capitalize + " locations:\n"

    url_locations.each do |location|
      output << "\t" << location << "\n"
    end

    output
  end

end
