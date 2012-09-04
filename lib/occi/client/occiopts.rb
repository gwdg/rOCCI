require 'ostruct'
require 'optparse'

class OcciOpts

  def self.parse(args)

    options = OpenStruct.new
    options.debug = false
    options.verbose = false
    options.log = {:out => STDERR, :level => OCCI::Log::WARN}
    options.endpoint = "https://localhost:3300/"
    options.auth = {:type => "none", :user_cert => ENV['HOME'] + "/.globus/usercred.pem", :ca_path => "/etc/grid-security/certificates"}
    options.media_type = nil
    options.mixins = {}

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: occi [OPTIONS]"

      opts.separator ""
      opts.separator "Options:"

      opts.on("--endpoint URI", String, "OCCI server URI, defaults to '#{options.endpoint}'") do |endpoint|
        options.endpoint = endpoint
      end

      opts.on("--auth METHOD", ["x509", "basic", "digest", "none"], "Auth. method to be used, defaults to '#{options.auth[:type]}'") do |auth|
        options.auth[:type] = auth
      end

      opts.on("--username USER", String, "") do |username|
        options.auth[:username] = username
      end

      opts.on("--password PASSWORD", String, "") do |password|
        options.auth[:password] = password
        options.auth[:user_cert_password] = password
      end

      opts.on("--ca-path PATH", String, "Path to CA certificates, defaults to '#{options.auth[:ca_path]}'") do |ca_path|
        options.auth[:ca_path] = ca_path
      end

      opts.on("--user-cred X509_CREDENTIALS", String, "Path to user's x509 credentials, defaults to '#{options.auth[:user_cert]}'") do |user_cred|
        options.auth[:user_cert] = user_cred
      end

      opts.on("--media-type MEDIA_TYPE", [:json, :xml, :plain, :none], "Force media type, defaults to 'none'") do |media_type|
        
        case media_type
        when :json
          options.media_type = "application/occi+json,text/plain;q=0.5"
        when :xml
          options.media_type = "application/occi+xml,text/plain;q=0.5"
        when :plain
          options.media_type = "text/plain;q=0.5"
        else
          options.media_type = nil
        end

      end

      opts.on("--resource RESOURCE", String, "Resource to be queried (e.g. network, compute, storage etc.), required") do |resource|
        options.resource = resource
      end

      opts.on("--do ACTION", String, "Action to be performed on the resource (e.g. list, describe, delete etc.), required") do |job|
        options.do = job
      end

      opts.on("--mixin NAME", String, "Type and name of the mixin as TYPE#NAME (e.g. os_tpl#monitoring, resource_tpl#medium)") do |mixin|
        parts = mixin.split("#")

        raise "Unknown mixin format! Use TYPE#NAME!" unless parts.length == 2

        options.mixins[parts[0]] = [] if options.mixins[parts[0]].nil?
        options.mixins[parts[0]] << parts[1]
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

    mandatory = [:resource, :do]
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
