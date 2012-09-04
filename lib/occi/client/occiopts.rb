require 'ostruct'
require 'optparse'

class OcciOpts

  def self.parse(args)

    options = OpenStruct.new 
    options.debug = false
    options.log_to = STDERR
    
    opts = OptionParser.new do |opts|
      opts.banner = "Usage: occi [OPTIONS]"

      opts.separator ""
      opts.separator "Options:"

      opts.on("--resource RESOURCE", String, "") do |resource|
        options.resource = resource
      end

      opts.on("--do ACTION", String, "") do |job|
        options.do = job
      end

      opts.on("--log-to OUTPUT", [:stdout, :stderr], "Logger target [stdout|stderr], defaults to stderr") do |log_to|
        options.log_to = STDOUT if log_to == :stdout
      end

      opts.on_tail("--debug", "Enable debugging messages") do |debug|
        options.debug = debug
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

    mandatory = [:resource, :do, :log_to]
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
