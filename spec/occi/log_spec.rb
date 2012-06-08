require "rspec"
require 'occi/log'

module OCCI
  describe Log do
    describe "initialize" do
      it "should initialize a new logger" do
        OCCI::Log.new(STDOUT, OCCI::Log::INFO)
      end
    end
  end

  describe "log messages" do
    it "should log into an IO object" do
      r, w = IO.pipe
      OCCI::Log.new(w, OCCI::Log::INFO)
      OCCI::Log.info("Test")
    end
  end
end