require "rspec"
require 'occi/log'

module Occi
  describe Log do

    describe "log messages" do
      it "should log a message to a pipe" do
        r, w = IO.pipe
        logger = Occi::Log.new(w)
        logger.level = Occi::Log::INFO
        Occi::Log.info("Test")
        r.readline.include?("Test")
      end
    end
  end
end