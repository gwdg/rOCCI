require 'logger'
require 'active_support/notifications'

module OCCI
  class Log

    include Logger::Severity

    attr_reader :logger

    # creates a new OCCI logger
    # @param [IO,String] log_dev The log device.  This is a filename (String) or IO object (typically +STDOUT+,
    #  +STDERR+, or an open file).
    def initialize(log_dev)
      if log_dev.kind_of? Logger
        @logger = log_dev
      else
        @logger = Logger.new(log_dev)
      end

      # subscribe to log messages and send to logger
      @log_subscriber = ActiveSupport::Notifications.subscribe("log") do |name, start, finish, id, payload|
        @logger.log(payload[:level], payload[:message])
      end
    end

    # @param [Logger::Severity] severity
    def level=(severity)
      @logger.level = severity
    end

    # @return [Logger::Severity]
    def level
      @logger.level
    end

    # @see info
    def self.debug(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::DEBUG, :message => message)
    end

    # Log an +INFO+ message
    # @param [String] message the message to log; does not need to be a String
    def self.info(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::INFO, :message => message)
    end

    # @see info
    def self.warn(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::WARN, :message => message)
    end

    # @see info
    def self.error(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::ERROR, :message => message)
    end

    # @see info
    def self.fatal(message)
      ActiveSupport::Notifications.instrument("log", :level => Logger::FATAL, :message => message)
    end
  end
end