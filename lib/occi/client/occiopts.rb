require 'ostruct'
require 'optparse'

class OcciOpts

  def self.parse(args)

    options = OpenStruct.new
    
    options.debug = false
    options.verbose = false
    
    options.log = {}
    options.log[:out] = STDERR
    options.log[:level] = OCCI::Log::WARN
    
    options.endpoint = "https://localhost:3300/"
    
    options.auth = {}
    options.auth[:type] = "none"
    options.auth[:user_cert] = ENV['HOME'] + "/.globus/usercred.pem"
    options.auth[:ca_path] = "/etc/grid-security/certificates"
    options.auth[:username] = "anonymous"
    
    options.media_type = "application/occi+json"

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: occi [OPTIONS]"

      opts.separator ""
      opts.separator "Options:"

      opts.on("--endpoint URI", String, "OCCI server URI, defaults to '#{options.endpoint}'") do |endpoint|
        options.endpoint = endpoint
      end

      opts.on("--auth METHOD", [:x509, :basic, :digest, :none], "Authentication method, defaults to '#{options.auth[:type]}'") do |auth|
        options.auth[:type] = auth.to_s
      end

      opts.on("--username USER", String, "Username for basic or digest authentication, defaults to '#{options.auth[:username]}'") do |username|
        options.auth[:username] = username
      end

      opts.on("--password PASSWORD", String, "Password for basic, digest or x509 authentication") do |password|
        options.auth[:password] = password
        options.auth[:user_cert_password] = password
      end

      opts.on("--ca-path PATH", String, "Path to CA certificates, defaults to '#{options.auth[:ca_path]}'") do |ca_path|
        options.auth[:ca_path] = ca_path
      end

      opts.on("--user-cred X509_CREDENTIALS", String, "Path to user's x509 credentials, defaults to '#{options.auth[:user_cert]}'") do |user_cred|
        options.auth[:user_cert] = user_cred
      end

      opts.on("--media-type MEDIA_TYPE", ["application/occi+json", "application/occi+xml", "text/plain"], "Media type for client <-> server communication, defaults to '#{options.media_type}'") do |media_type|
        options.media_type = media_type
      end

      opts.on("--resource RESOURCE", String, "Resource to be queried (e.g. network, compute, storage etc.), required") do |resource|
        options.resource = resource
      end

      opts.on("--resource-title TITLE", String, "Resource title for new resources") do |resource_title|
        options.resource_title = resource_title
      end

      opts.on("--action ACTION", [:list, :describe, :create, :delete, :trigger], "Action to be performed on the resource, required") do |action|
        options.action = action
      end

      opts.on("--mixin NAME", String, "Type and name of the mixin as TYPE#NAME (e.g. os_tpl#monitoring, resource_tpl#medium)") do |mixin|
        parts = mixin.split("#")

        raise "Unknown mixin format! Use TYPE#NAME!" unless parts.length == 2

        options.mixin = {} if options.mixin.nil?
        options.mixin[parts[0]] = [] if options.mixin[parts[0]].nil?
        options.mixin[parts[0]] << parts[1]
      end

      opts.on("--trigger-action TRIGGER_ACTION", String, "Action to be triggered on the resource") do |trigger_action|
        options.trigger_action = trigger_action
      end

      opts.on("--log-to OUTPUT", [:STDOUT, :stdout, :STDERR, :stderr], "Log to the specified device, defaults to 'STDERR'") do |log_to|
        options.log[:out] = STDOUT if log_to == :stdout or log_to == :STDOUT
      end

      opts.on_tail("--debug", "Enable debugging messages") do |debug|
        options.debug = debug
        options.log[:level] = OCCI::Log::DEBUG
      end

      opts.on_tail("--verbose", "Be more verbose, less intrusive than debug mode") do |verbose|
        options.verbose = verbose
        options.log[:level] = OCCI::Log::INFO unless options.log[:level] == OCCI::Log::DEBUG
      end

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit!
      end

      opts.on_tail("--version", "Show version") do
        puts OCCI::VERSION
        exit!(true)
      end

    end

    begin
      opts.parse!(args)
    rescue Exception => ex
      puts ex.message.capitalize
      puts opts
      exit!
    end

    mandatory = []

    if options.action == :trigger
      mandatory << :trigger_action
    end

    if options.action == :create
      mandatory << :mixin << :resource_title
    end

    mandatory.concat [:resource, :action]
    
    options_hash = options.marshal_dump

    missing = mandatory.select{ |param| options_hash[param].nil? }
    if not missing.empty?
      puts "Missing required arguments: #{missing.join(', ')}"
      puts opts
      exit!
    end

    options
  end

end
