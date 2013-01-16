require "rspec"
require 'occi/log'

module Occi
  describe Log do

    it "logs a message to a pipe" do
      r, w = IO.pipe
      logger = Occi::Log.new(w)
      logger.level = Occi::Log::INFO
      Occi::Log.info("Test")
      r.readline.include?("Test")
      logger.close
    end

  end
end
