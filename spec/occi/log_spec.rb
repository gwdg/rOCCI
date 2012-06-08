require "rspec"
require 'occi/log'

module OCCI
  describe Log do

    describe "log messages" do
      it "should log a message to a pipe" do
        r, w = IO.pipe
        OCCI::Log.new(w, OCCI::Log::INFO)
        OCCI::Log.info("Test")
        r.readline.include?("Test")
      end
    end
  end
end