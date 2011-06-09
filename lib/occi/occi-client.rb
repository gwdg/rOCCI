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
# Require Ruby Gems and OCCI classes

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

# OCCI Infrastructure classes
require 'occi/infrastructure/Compute'
require 'occi/infrastructure/Storage'
require 'occi/infrastructure/Network'
require 'occi/infrastructure/Networkinterface'
require 'occi/infrastructure/StorageLink'
require 'occi/infrastructure/Ipnetworking'
#require 'occi/infrastructure/Reservation'

# OCCI HTTP rendering
require 'occi/rendering/http/Renderer'
require 'occi/rendering/http/LocationRegistry'

##############################################################################
# Initialize logger

$stdout.sync = true
$log = Logger.new(STDOUT)

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

# registry for the locations of all OCCI objects
$locationRegistry = OCCI::Rendering::HTTP::LocationRegistry.new

$objects = []

# Version
OCCI_CLIENT_VERSION = "0.1"

# available commands
SUPPORTED_COMMANDS  = [:create, :retrieve, :delete, :call, :link, :test, :help]

# Defaults for http request options 
REQUEST_DEFAULTS  = { :method        => :get,
                      :headers       => {:Accept => "text/occi"},
                      :timeout       => 10000,  # milliseconds
                      :cache_timeout => 0       # seconds
                    } 

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
def dump_headers(response)
    response.headers_hash.each do |key, value|
      $log.info("#{key} = #{value}")
    end
end

# ---------------------------------------------------------------------------------------------------------------------
def get_default_request(params = {})
  url       = %<#{GENERAL_OPTIONS[:host]}:#{GENERAL_OPTIONS[:port]}#{params[:location] || "/"}>
  request   = Typhoeus::Request.new(url, REQUEST_DEFAULTS.merge(params))
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
def get_categories
  request = get_default_request(:location => "/-/")
  request.on_complete do |response|
    check_response(response)
    response.headers_hash.each do |key, value|
      $log.debug("#{key} = #{value}")
    end
  end
  return request
end

# ---------------------------------------------------------------------------------------------------------------------
def create_resource(kind, attributes)

  request = get_default_request(:method => :post)

  headers = OCCI::Rendering::HTTP::Renderer.render_category_type(kind)
  headers = OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_attributes(attributes))

  request.headers.merge!(headers)

  request.on_complete do |response|
    check_response(response)
    $log.info("Resource of kind [#{kind}] created under location: #{response.headers_hash["Location"]}")
    resource_uri = URI.parse(response.headers_hash["Location"])
    $objects << resource_uri.path
  end

  return request
end

# ---------------------------------------------------------------------------------------------------------------------
def retrieve_resource(location)

  request = get_default_request(  :method   => :get,
                                  :location => location)

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
def delete_resource(location)

  request = get_default_request(  :method   => :delete,
                                  :location => location)

  request.on_complete do |response|
    check_response(response)
    if response.body == "OK"
      $log.debug("Resource under location [#{location}] has been deleted!")
      $objects.delete(location)
    else
      $log.error("Could not delete resource under location [#{location}]!")
    end
  end

  return request
end

# ---------------------------------------------------------------------------------------------------------------------
def trigger_action(location, action, parameters = {})

  request = get_default_request(  :method   => :post,
                                  :location => "#{location}?action=#{action.category.term}")
  headers = {}
  headers = OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_category_type(action))
  headers = OCCI::Rendering::HTTP::Renderer.merge_headers(headers, OCCI::Rendering::HTTP::Renderer.render_attributes(parameters))
  request.headers.merge!(headers)

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
def test_compute_torture(options)
  queue = []
  10.times  { queue << create_resource(OCCI::Infrastructure::Compute::KIND, options[:attributes]) }
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def test_compute_torture_2(options)
  queue = []
  100.times { queue << create_resource(OCCI::Infrastructure::Compute::KIND, options[:attributes]) }
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def test_compute_torture_3(options)
  queue = []
  1000.times  { queue << create_resource(OCCI::Infrastructure::Compute::KIND, options[:attributes]) }
  return queue
end

# ---------------------------------------------------------------------------------------------------------------------
def test_default(options)
  test_compute_torture(options)
end

# ---------------------------------------------------------------------------------------------------------------------
def clean_up
  queue = []
  $objects.each { |location| queue << delete_resource(location)}
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
  queue_requests(hydra, [retrieve_resource(options[:location])])
  hydra.run
end

# ---------------------------------------------------------------------------------------------------------------------
def process_delete_command(options)
  hydra = get_hydra
  queue_requests(hydra, [delete_resource(options[:location])])
  hydra.run
end


# ---------------------------------------------------------------------------------------------------------------------
def process_call_command(options)

  action = OCCI::Infrastructure::Compute::ACTION_START

  hydra = get_hydra
  queue_requests(hydra, [trigger_action(options[:location], action, options[:attributes])])
  hydra.run
end


# ---------------------------------------------------------------------------------------------------------------------
begin
  
  # Options defaults

  GENERAL_OPTIONS =   { :config_file      => nil,                 # Use given config file if != nil instead of command line options
                        :host             => "http://localhost",  # Host http address to use
                        :port             => 4567,                # Port to use
                        :timeout          => 10000,               # Timeout in ms to use for http requests
                        :command          => "test",              # Which command should be run
                        :log_level        => "debug",             # Logging level to use
                        :log_file         => nil                  # Use log file if != nil instead of stdout
                      }
                        
  CREATE_OPTIONS  =   { :kind             => "compute",           # Kind of resource to create
                        :attributes       => {},                  # Attributes
                        :location         => nil                  # Location where resource should be created
                      }
  
  RETRIEVE_OPTIONS =  { :location         => "/-/"                # List object(s) under the given location
                      }
  
  CALL_OPTIONS    =   { :location         => nil,                 # Resource on which to trigger the action
                        :action           => nil,                 # Term / name of the action
                        :attributes       => {}                   # Parameters of the action
                      }
  
  LINK_OPTIONS    =   {
                      }
  
  DELETE_OPTIONS  =   { :location         => nil                  # Delete object(s) under the given location
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

    opts.on( '-h', '--host HOSTNAME', 'Connect to host' ) do |host|
      puts GENERAL_OPTIONS[:config_file] = config
      GENERAL_OPTIONS[:host] = host
    end
    
    opts.on( '-p', '--port PORT', Integer, 'Connect on port' ) do |port|
      GENERAL_OPTIONS[:port] = port
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

    opts.on( '-t', '--tests test1, test2, test3', Array, 'Predefined tests to run' ) do |tests|
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
      CREATE_OPTIONS[:location] = location
    end    
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "retrieve" command specific options!
  
  RETRIEVE_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-l', '--location location', 'Location where the resourse should be created' ) do |location|
      RETRIEVE_OPTIONS[:location] = location
    end    
  end

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "delete" command specific options!
  
  DELETE_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-l', '--location location', 'Location of the resourse to be deleted' ) do |location|
      DELETE_OPTIONS[:location] = location
    end    
  end

#  CALL_OPTIONS    =   { :location         => nil,                 # Resource on which to trigger the action
#                        :action           => nil,                 # Term / name of the action
#                        :attributes       => {}                   # Parameters of the action
#                      }

  # ---------------------------------------------------------------------------------------------------------------------
  # Parse "call" command specific options!
  
  CALL_COMMAND_PARSER = OptionParser.new do |opts|

    opts.on( '-l', '--location STRING', 'Location of the resource on which the action should be called' ) do |location|
      CALL_OPTIONS[:location] = location
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

  # Delegate command processing
  send("process_#{command.downcase}_command", COMMAND_OPTIONS)

#  trigger_action($objects[0], OCCI::Infrastructure::Compute::ACTION_START)
#  $hydra.run
  
end
