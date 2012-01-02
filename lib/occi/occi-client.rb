##############################################################################
#  Copyright 2011 Service Computing group, TU Dortmund
#  
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#  
#      http://www.apache.org/licenses/LICENSE-2.0
#  
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
##############################################################################

##############################################################################
# Description: OCCI RESTful Web Service
# Author(s): Hayati Bice, Florian Feldhaus, Piotr Kasprzak
##############################################################################

##############################################################################
# Require Ruby Gems

# gems
require 'rubygems'
require 'typhoeus'
require 'logger'

# Ruby standard library
require 'uri'
require 'optparse'
require 'benchmark'

# Server configuration
require 'occi/Configuration'

# ANTLR based parser
require 'occi/rendering/http/OCCIParser'

##############################################################################
# Initialize logger

$stdout.sync = true
$log = Logger.new(STDOUT)

##############################################################################
# Require OCCI classes

# registry for all categories (e.g. kinds, mixins, actions)
require 'occi/CategoryRegistry'

# OCCI HTTP rendering
require 'occi/rendering/Rendering'
require 'occi/rendering/http/LocationRegistry'

# OCCI Infrastructure classes
require 'occi/infrastructure/Compute'
require 'occi/infrastructure/Storage'
require 'occi/infrastructure/Network'
require 'occi/infrastructure/Networkinterface'
require 'occi/infrastructure/StorageLink'
require 'occi/infrastructure/Ipnetworking'

require 'occi/extensions/NFSStorage'
#require 'occi/infrastructure/Reservation'

##############################################################################
# Read configuration file and set loglevel

#if ARGV[0] != nil
#CONFIGURATION_FILE = ARGV[0]
#else
#  $log.error("A configuration file needs to be provided in the arguments for occi-client")
#  break
#end

#$config = OCCI::Configuration.new(CONFIGURATION_FILE)

#if $config['LOG_LEVEL'] != nil
#  $log.level = case $config['LOG_LEVEL'].upcase
#  when 'FATAL' then Logger::FATAL
#  when 'ERROR' then Logger::ERROR
#  when 'WARN' then Logger::WARN
#  when 'INFO' then Logger::INFO
#  when 'DEBUG' then Logger::DEBUG
#  else
#    $log.warn("Invalid loglevel specified. Loglevel set to INFO")
#    Logger::INFO
#  end
#end

class Hash
  def to_s
    values = []
    each do |name, value|
      values << "#{name}='#{value}'"
    end
    return "[" + values.join(", ") + "]"
  end
end

class Array
  def to_s
    return "[" + self.join(", ") + "]"
  end
end

class Typhoeus::Request
  
  # Make it compatible with standard request object
  def [](header)
    return headers[header]
  end
  
  def []=(header, value)
    headers[header] = value
  end
  
  def write(message)
    # Just ignore...
  end
end

# Basic resource abstraction
class Resource

  attr_accessor :location

  attr_reader   :kind
  attr_reader   :attributes
  attr_reader   :links
  
  def initialize(kind, attributes, links = [])
    @kind         = kind
    @attributes   = attributes
    @links        = links
  end
end

class Link
  
  attr_reader :kind
  attr_reader :attributes
  attr_reader :target
  
  def initialize(kind, attributes, target)
    @kind         = kind
    @attributes   = attributes
    @target       = target
  end  
end


# resource_id -> resource hash
$resources = {}

$type_locations = {}

# Version
OCCI_CLIENT_VERSION = "0.2"

# available commands
SUPPORTED_COMMANDS  = [:create, :retrieve, :delete, :call, :link, :test, :help]

# Defaults for http request options 
REQUEST_DEFAULTS  = { :method        => :get,
                      :headers       => {:Accept => "text/occi", "Content-Type" => "text/occi"},
                      :timeout       => 10000,  # milliseconds
                      :cache_timeout => 0       # seconds
                    } 

# Used for rendering of requests
$rendering = OCCI::Rendering::Rendering.new()
OCCI::Rendering::Rendering.prepare_renderer("text/occi")

# ---------------------------------------------------------------------------------------------------------------------
def check_response(response)

  return true if response.success?

  if response.timed_out?
    # Response timed out
    $log.error("Response timed out: #{response.time} seconds!")
    return
  end

  if response.code == 0
    # Could not get an http response, something's wrong.
    $log.error("No http response received: #{response.curl_error_message}")
    return
  end

  # Received a non-successful http response.
  $log.error("HTTP request failed: " + response.code.to_s)

end

# ---------------------------------------------------------------------------------------------------------------------
# Execute just one request through hydra
def execute_request(request)
  hydra = get_hydra
  queue_requests(hydra, [request])
  hydra.run
end

# ---------------------------------------------------------------------------------------------------------------------
def dump_headers(response)
    response.headers_hash.each do |key, value|
      $log.info("#{key} = #{value}")
    end
end

# ---------------------------------------------------------------------------------------------------------------------
def remove_quotes(string)
  string.gsub!(/^["|']?(.*?)["|']?$/, '\1')
end

# ---------------------------------------------------------------------------------------------------------------------
# Construct request object using absolute or relative paths and also allowing for parameter override

def get_default_request(params = {})
  if params.has_key?(:absolute)
    url = params[:absolute]
  else
    url = %<#{GENERAL_OPTIONS[:host]}:#{GENERAL_OPTIONS[:port]}#{params[:relative] || "/"}>
  end
  $log.debug("*** request url: " + url.to_s)
  request         = Typhoeus::Request.new(url, REQUEST_DEFAULTS.clone.merge(params))

  # Explicitly clone the headers hash so that it is not reused between requests  
  request.headers = REQUEST_DEFAULTS[:headers].clone

  return request  
end

# ---------------------------------------------------------------------------------------------------------------------
def get_version
  request = get_default_request
  request.on_complete do |response|
    check_response(response)
    $log.debug("Server version: " + response.headers_hash["Server"])
  end
  return request
end
 
# ---------------------------------------------------------------------------------------------------------------------
# Return attribute hash (name -> value) from occi attributes string

def parse_attributes(attributes_string)
  OCCI::Parser.new(attributes_string).attributes_attr
end

# ---------------------------------------------------------------------------------------------------------------------
def get_categories
  request = get_default_request(:relative => "/-/")
  request.on_complete do |response|
    check_response(response)
    response.headers_hash.each do |key, value|
      $log.debug("#{key} = #{value}")
    end
  end
  return request
end

# ---------------------------------------------------------------------------------------------------------------------
def self.render_resource_attached_link(link)

  attributes = link.attributes.map { |key, value| %Q{#{key}="#{value}"} unless value.empty? }.join(';').to_s
  attributes << ";" unless attributes.empty?

  link_string = %Q{<#{link.target.location}>;rel="#{link.target.kind.type_identifier}";category="#{link.kind.type_identifier}";#{attributes}}

  return link_string
end

# ---------------------------------------------------------------------------------------------------------------------
# Create resource with specified kind and attributes and save its location

def create_resource(id, resource)

  $resources[id] = resource;

  request = get_default_request(:method => :post)

  $rendering.prepare_renderer();
  $rendering.render_category_short( resource.kind)
  $rendering.render_attributes(     resource.attributes)
 
  data = $rendering.data
  
  request["Category"]         = data[OCCI::Rendering::HTTP::TextRenderer::CATEGORY].join(',')
  request["X-OCCI-Attribute"] = data[OCCI::Rendering::HTTP::TextRenderer::OCCI_ATTRIBUTE].join(',')
  
#  $rendering.render_response(request)

  # Add attached links
  unless resource.links.empty?
    link_header = resource.links.collect { |link| render_link(link) }
    request["Link"] = link_header
  end

  request.on_complete do |response|
    check_response(response)
    $log.info("Resource of kind [#{resource.kind}] created under location: #{response.headers_hash["Location"]}")
    resource_uri = URI.parse(response.headers_hash["Location"])
    $resources[id].location = resource_uri.path
  end

  return request
end

# ---------------------------------------------------------------------------------------------------------------------
# Build a kind -> location hash for resource types

def build_type_to_location_hash()

  $log.debug("Building type -> location hash...")
  
  request = get_default_request(:relative => "/-/")

  request.on_complete do |response|
    categories = response.headers_hash["Category"].split(",")
    categories.each do |category|
      desc_elements = category.strip.split(";")
      location = nil; scheme = nil
      desc_elements.each do |element|
        element.strip!
        if /location=(.*)/ =~ element
          location  = /location=(.*)/.match(element)[1]
          remove_quotes(location)
        end
        if /scheme=(.*)/ =~ element
          scheme    = /scheme=(.*)/.match(element)[1]
          remove_quotes(scheme)
        end
      end

      # Check if category string could be parsed correctly
      term = desc_elements.first
      if location.nil? or scheme.nil?
        next
      end

      $log.debug("#{scheme}#{term} => #{location}")
      $type_locations[scheme + term] = location;
    end
  end

  execute_request(request)
end

# ---------------------------------------------------------------------------------------------------------------------
# Find a resource of the given kind with the provided name and return an appropriate resource object

def find_resource(kind, name)

  # Use strings as kind ids
  kind = kind.type_identifier if kind.kind_of?(OCCI::Core::Kind)

  $log.debug("Searching for resource of kind '#{kind}' with name '#{name}'...")

  resource  = nil
  request   = get_default_request(:absolute => $type_locations[kind])

  request.on_complete do |response|

    $log.debug("*** header: " + response.headers_hash.inspect)
    locations = response.headers_hash["X-OCCI-Location"].split(",")
    locations.each do |location|

      sub_request = get_default_request(:absolute => location)
      sub_request.on_complete do |response|

        attributes = parse_attributes(response.headers_hash["X-OCCI-Attribute"])
        
        if /#{name}/i =~ attributes["occi.core.title"]
          
          # Derive resource KIND from category header
          resource_kind = nil
          categories_hash_array = OCCI::Parser.new(response.headers_hash["Category"]).category_values
          categories_hash_array.each do |kind_hash|
            if kind_hash.clazz == "kind"
              resource_kind = OCCI::CategoryRegistry.get_by_id(kind_hash.scheme + kind_hash.term)
            end
          end
       
          resource = Resource.new(resource_kind, attributes)
          $log.debug("=> found at: " + location.to_s)
          resource.location = location
        end
      end
 
      execute_request(sub_request)
 
    end
  end
  
  execute_request(request)

  return resource
end

# ---------------------------------------------------------------------------------------------------------------------
def retrieve_resource(location)

  request = get_default_request(:relative => location)

  request.on_complete do |response|
    check_response(response)
    if response.body == "OK"
      $log.debug("Retrieved resource under location [#{location}]!")
      dump_headers(response)
    else
      $log.error("Could not retrieve resource under location [#{location}]!")
    end
  end

  return request
end

# ---------------------------------------------------------------------------------------------------------------------
def delete_resource(id)

  request = get_default_request(  :method   => :delete,
                                  :relative => $resources[id].location)

  request.on_complete do |response|
    check_response(response)
#    if response.body == "OK"
      $log.debug("Resource under location [#{location}] has been deleted!")
      $resources.delete(id)     
#      $objects.delete(location)
#    else
#      $log.error("Could not delete resource under location [#{location}]!")
#    end
  end

  return request
end

# ---------------------------------------------------------------------------------------------------------------------
def trigger_action(location, action, parameters = {})

  request = get_default_request(  :method   => :post,
                                  :relative => "#{location}?action=#{action.category.term}")

  OCCI::Rendering::HTTP::Renderer.render_category_type(action,  request)
  OCCI::Rendering::HTTP::Renderer.render_attributes(parameters, request)

  request.on_complete do |response|
    check_response(response)
    if response.body == "OK"
      $log.debug("Triggered action [#{action}] on resource under location [#{location}] with parameters [#{parameters}]!")
    else
      $log.error("Could not trigger action [#{action}] on resource under location [#{location}] with parameters [#{parameters}]!")
    end
  end

  return request  
end

# ---------------------------------------------------------------------------------------------------------------------
def test_validate(options)
  queue = []
  queue << retrieve_resource('/')
  queue << retrieve_resource('/-/')
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def test_compute_torture(options)
  queue = []
  10.times  { |id| queue << create_resource(id, Resource.new(OCCI::Infrastructure::Compute::KIND, options[:attributes])) }
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def test_compute_torture_2(options)
  queue = []
  100.times { |id| queue << create_resource(id, Resource.new(OCCI::Infrastructure::Compute::KIND, options[:attributes])) }
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def test_compute_torture_3(options)
  queue = []
  1000.times  { |id| queue << create_resource(id, Resouzrce.new(OCCI::Infrastructure::Compute::KIND, options[:attributes])) }
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def test_nfsstorage(options)
  
  queue = []

  # Create nfsstorage resource
  
  nfsstorage_attributes = {
    'occi.storage.size' => "1024"
  }
  
  nfsstorage = Resource.new(OCCI::Infrastructure::NFSStorage::KIND, nfsstorage_attributes);  
  execute_request(create_resource("nfsstorage", nfsstorage))
  
  # Find correct network resource
  
  network = find_resource(OCCI::Infrastructure::Network::KIND, "GWDG-Cloud")
  $resources["network"] = network
  
  # Create links

  storage_link_attributes = {
    'occi.storagelink.deviceid'     => "nfs",
    'occi.storagelink.mountpoint'   => "134.76.9.66:/nfs_test",
    'occi.storagelink.state'        => "active"
  }
  
  storage_link = Link.new(OCCI::Infrastructure::StorageLink::KIND, storage_link_attributes)
  
  network_link_attributes = {
  }
  
  network_link = Link.new(OCCI::Core::Link::KIND, network_link_attributes)
  
  # Create compute resource linking both
  
  compute_attributes = {
    'occi.compute.cores'          => "1",
    'occi.compute.architecture'   => "",
    'occi.compute.state'          => "",
    'occi.compute.hostname'       => "NFSStorage TestVM",
    'occi.compute.memory'         => "1024",
    'occi.compute.speed'          => ""
  }

  compute_resource = Resource.new(OCCI::Infrastructure::Compute::KIND, compute_attributes, [storage_link, network_link]);
  execute_request(create_resource("compute", compute))
    
  # FIXME

end

# ---------------------------------------------------------------------------------------------------------------------
def test_default(options)
#  queue = []
#  queue << create_resource(OCCI::Infrastructure::Compute::KIND, options[:attributes])
#  return queue

#  test_compute_torture(options)

  test_nfsstorage(options)
end

# ---------------------------------------------------------------------------------------------------------------------
def clean_up
  queue = []
#  $objects.each { |location| queue << delete_resource(location)}
  $resources.each_key { |id| queue << delete_resource($resources[id])}
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def get_hydra

  # Run the requests through Hydra
  hydra = Typhoeus::Hydra.new(:max_concurrency => 1)

  # No memoization
  hydra.disable_memoization
  
  return hydra
end

# ---------------------------------------------------------------------------------------------------------------------
def queue_requests(hydra, requests)
  requests.each {|request| hydra.queue(request)}
end

# ---------------------------------------------------------------------------------------------------------------------
def process_test_command(options)

  tests = private_methods.grep /^test_/

  options[:tests].collect! {|test| "test_" + test}
  $log.debug("Requested following tests to run: #{options[:tests]}")
  $log.debug("Available tests for running: #{tests}")
  valid_tests   = options[:tests] & tests
  unknown_tests = options[:tests] - valid_tests
  
  unknown_tests.each do |test|
    $log.warn("Unknown test: #{test} => ignoring")
  end
  
  if valid_tests.empty?
    $log.info("No tests to run => exiting...")
    exit
  end
  
  $log.info("Running following tests: #{valid_tests} [#{options[:repeat]}] times...")
  
  # Run the requests through Hydra
  hydra = Typhoeus::Hydra.new(:max_concurrency => options[:max_concurrency])

  # No memoization
  hydra.disable_memoization

  # Run tests!
  i = options[:repeat]
  while i != 0 do

    $log.info("=============================================================================")
    $log.info("Run [#{options[:repeat] - i + 1} / #{options[:repeat]}]")
    $log.info("=============================================================================")

    valid_tests.each do |test|

      $log.info("-----------------------------------------------------------------------------")
      $log.info("Running test: #{test}")
      $log.info("-----------------------------------------------------------------------------")
      
      queue_test_requests_time  = Benchmark.measure("Queuing requests for test:") {  queue_requests(hydra, send(test, options)) }
      run_test_requests_time    = Benchmark.measure("Running requests for test:") {  hydra.run }

      if options[:cleanup]
        $log.info("Cleaning up...")
        queue_cleanup_requests_time  = Benchmark.measure("Queuing requests for cleanup:") { queue_requests(hydra, clean_up) }
        run_cleanup_requests_time    = Benchmark.measure("Running requests for cleanup:") { hydra.run }
      end

      $log.info("Time:")
      $log.info(queue_test_requests_time.to_a.to_s)
      $log.info(run_test_requests_time.to_a.to_s)
      $log.info(queue_cleanup_requests_time.to_a.to_s)
      $log.info(run_cleanup_requests_time.to_a.to_s)

    end
    $log.info("=============================================================================")
    i -= 1 if i > 0
  end
end

# ---------------------------------------------------------------------------------------------------------------------
def process_create_command(options)

  # Search all scopes under OCCI for a kind that matches
  scopes  = [Kernel.const_get("OCCI")]
  kind    = nil
  while !scopes.empty? && kind == nil do
    scope     = scopes.shift
#    $log.debug("Searching scope: #{scope}")
    constants = scope.constants
#    $log.debug("Constants: #{constants}")
    if scope.name.downcase.end_with?(options[:kind].downcase)
      constants.each do |constant|
#        $log.debug("-> Constant: #{constant}")
        if constant == "KIND"
          # Found kind
          kind = scope.const_get(constant)
          break
        end
      end
    end
    constants.each {|constant| scopes << scope.const_get(constant) if scope.const_get(constant).kind_of? Module}
    
  end
  
  raise "Could not find appropriate kind definition for: #{options[:kind]}" if kind == nil

  hydra = get_hydra
  queue_requests(hydra, [create_resource(kind, options[:attributes])])
  hydra.run
end

# ---------------------------------------------------------------------------------------------------------------------
def process_retrieve_command(options)
  hydra = get_hydra
  queue_requests(hydra, [retrieve_resource(options[:relative])])
  hydra.run
end

# ---------------------------------------------------------------------------------------------------------------------
def process_delete_command(options)
  hydra = get_hydra
  queue_requests(hydra, [delete_resource(options[:relative])])
  hydra.run
end


# ---------------------------------------------------------------------------------------------------------------------
def process_call_command(options)

  action = OCCI::Infrastructure::Compute::ACTION_START

  hydra = get_hydra
  queue_requests(hydra, [trigger_action(options[:relative], action, options[:attributes])])
  hydra.run
end


# ---------------------------------------------------------------------------------------------------------------------
begin
  
  # Options defaults

  GENERAL_OPTIONS =   { :config_file      => nil,                 # Use given config file if != nil instead of command line options
                        :host             => "http://localhost",  # Host http address to use
                        :port             => 3000,                # Port to use
                        :timeout          => 10000,               # Timeout in ms to use for http requests
                        :command          => "test",              # Which command should be run
                        :log_level        => "debug",             # Logging level to use
                        :log_file         => nil                  # Use log file if != nil instead of stdout
                      }
                        
  CREATE_OPTIONS  =   { :kind             => "compute",           # Kind of resource to create
                        :attributes       => {},                  # Attributes
                        :relative         => nil                  # Location where resource should be created
                      }
  
  RETRIEVE_OPTIONS =  { :relative         => "/-/"                # List object(s) under the given location
                      }
  
  CALL_OPTIONS    =   { :relative         => nil,                 # Resource on which to trigger the action
                        :action           => nil,                 # Term / name of the action
                        :attributes       => {}                   # Parameters of the action
                      }
  
  LINK_OPTIONS    =   {
                      }
  
  DELETE_OPTIONS  =   { :relative         => nil                  # Delete object(s) under the given location
                      }
  
  TEST_OPTIONS    =   { :tests            => ["default"],         # Predefined tests to run
                        :max_concurrency  => 1,                   # Max number of concurrent requests
                        :repeat           => 1,                   # Number of times the tests shall be repeated
                        :cleanup          => true                 # Destroy any created objects at the end?
                      }
  
  # ---------------------------------------------------------------------------------------------------------------------
  # Parse general options!
  
  OPTIONS_PARSER = OptionParser.new do |opts|

    # Set a banner, displayed at the top of the help screen.
    opts.banner = "Usage: occi-client.rb [general-options] command [command-options]"

    opts.on( '-c', '--config FILE', 'Read general options from config file' ) do |config|
      GENERAL_OPTIONS[:config_file] = config
    end

    opts.on( '-H', '--host HOSTNAME', 'Connect to host' ) do |host|
      puts GENERAL_OPTIONS[:config_file] = config
      GENERAL_OPTIONS[:host] = host
    end
    
    opts.on( '-p', '--port PORT', Integer, 'Connect on port' ) do |port|
      GENERAL_OPTIONS[:port] = port
    end
    
    opts.on( '-C', '--content-type MIME_TYPE', Integer, 'Content-Type and Accept for requests' ) do |conent_type|
      GENERAL_OPTIONS[:content_type] = conent_type
    end

    opts.on( '-t', '--timeout NUM', Integer, 'Timeout for http requests in milliseconds' ) do |timeout|
      GENERAL_OPTIONS[:timeout] = timeout
    end
    
    opts.on( '-l', '--log FILE', 'Log to file instead of stdout' ) do |log_file|
      GENERAL_OPTIONS[:log_file] = log_file
    end
  
    opts.on( '-v', '--log-level LEVEL', [:debug, :info, :warn, :error, :fatal], 'Log at given level' ) do |log_level|
      GENERAL_OPTIONS[:log_level] = log_level
    end

   # This displays the help screen, all programs are assumed to have this option.
    opts.on_tail("-h", "--help", "Display this screen") do
      puts opts
      exit
    end

    # Another typical switch to print the version.
    opts.on_tail("--version", "Show version") do
      puts "Version: occi-client v#{OCCI_CLIENT_VERSION} (ruby #{VERSION})"
      exit
    end      
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "test" command specific options!
  
  TEST_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-t', '--tests validate, test1, test2, test3', Array, 'Predefined tests to run' ) do |tests|
      TEST_OPTIONS[:tests] = tests
    end

    opts.on( '-m', '--max-concurrency NUM', Integer, 'Maximum number of concurrent http requests' ) do |max_concurrency|
      TEST_OPTIONS[:max_concurrency] = max_concurrency
    end

    opts.on( '-r', '--repeat NUM', Integer, 'Number of times the test(s) should be run' ) do |repeat|
      TEST_OPTIONS[:repeat] = repeat
    end
    
    opts.on( '-c', '--[no-]cleanup', 'Cleanup after a every test' ) do |do_cleanup|
      TEST_OPTIONS[:cleanup] = do_cleanup
    end
    
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "create" command specific options!
  
  CREATE_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-k', '--kind KIND', 'OCCI kind of the resource to be created (e.g. compute, storage, networkinterface, ...)' ) do |kind|
      CREATE_OPTIONS[:kind] = kind
    end

    opts.on( '-a', '--attributes attr=val1, attr2=val2, attr3=val3', Array, 'OCCI resource attributes' ) do |attributes_array|
      attributes = {}
      attributes_array.each do |key_value_pair|
        key_value_pair.match(%q{/^(.+)=['|"]?(.+)['|"]?$/}) {|match| attributes[match[0]] = match[1]}
      end
      $log.debug("Attributes for create resource command: #{attributes}")
      CREATE_OPTIONS[:attributes] = attributes
    end

    opts.on( '-l', '--location location', 'Location where the resourse should be created' ) do |location|
      CREATE_OPTIONS[:relative] = location
    end    
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "retrieve" command specific options!
  
  RETRIEVE_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-l', '--location location', 'Location where the resourse should be created' ) do |location|
      RETRIEVE_OPTIONS[:relative] = location
    end    
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "delete" command specific options!
  
  DELETE_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-l', '--location location', 'Location of the resourse to be deleted' ) do |location|
      DELETE_OPTIONS[:relative] = location
    end    
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "call" command specific options!
  
  CALL_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-l', '--location STRING', 'Location of the resource on which the action should be called' ) do |location|
      CALL_OPTIONS[:relative] = location
    end
    
    opts.on( '-a', '--action STRING', 'OCCI Category string (scheme + term) specifying the action' ) do |action|
      CALL_OPTIONS[:action] = action
    end

    opts.on( '-a', '--attributes attr=val1, attr2=val2, attr3=val3', Array, 'OCCI action attributes' ) do |attributes_array|
      attributes = {}
      attributes_array.each do |key_value_pair|
        key_value_pair.match(%q{/^(.+)=['|"]?(.+)['|"]?$/}) {|match| attributes[match[0]] = match[1]}
      end
      $log.debug("Attributes for create resource command: #{attributes}")
      CALL_OPTIONS[:attributes] = attributes
    end
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Find command and partitions command line args array accordingly
  command_position = -1
  ARGV.each_index do |index|
    if SUPPORTED_COMMANDS.include?(ARGV[index].to_sym)
      command_position = index
      break
    end
  end

  command = GENERAL_OPTIONS[:command].upcase 
  if command_position == -1
    # No command provided / command not recognized => use default
    general_argv = ARGV
  else
    general_options_argv  = command_position > 1 ? ARGV[0..command_position - 1] : []
    command               = ARGV[command_position].upcase
    command_options_argv  = ARGV[command_position + 1..-1]

    $log.debug("general argv: " + general_options_argv.to_s)
    $log.debug("command argv: " + command_options_argv.to_s)

    # Special case, just print help text and exit
    if command == "help".upcase
      help_on_command         = ARGV[command_position + 1]
      if help_on_command == nil
        # Only "help" provided wihout target command to provide help about => just print help on general options && exit
        puts OPTIONS_PARSER.to_s
        exit
      end
      HELP_ON_COMMAND_PARSER  = Kernel.const_get(help_on_command.upcase + "_COMMAND_PARSER")
      puts HELP_ON_COMMAND_PARSER.to_s
      exit
    end

    COMMAND_PARSER        = Kernel.const_get(command + "_COMMAND_PARSER")
    COMMAND_PARSER.parse(command_options_argv)
  end

  COMMAND_OPTIONS = Kernel.const_get(command + "_OPTIONS")

  OPTIONS_PARSER.parse(general_options_argv)
  
#  if ARGV.length >= 1
#    options[:command] = ARGV.shift
#  end

  $log.debug("Command line: " + ARGV.to_s)
  $log.debug("General options: " + GENERAL_OPTIONS.to_s)
  $log.debug("Command [#{command}] options: " + COMMAND_OPTIONS.to_s)

  build_type_to_location_hash

  # Delegate command processing
  send("process_#{command.downcase}_command", COMMAND_OPTIONS)

#  trigger_action($objects[0], OCCI::Infrastructure::Compute::ACTION_START)
#  $hydra.run
  
end
