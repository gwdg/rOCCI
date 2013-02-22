require 'rspec'
require 'occi/bin/occi_opts'

module Occi
  module Bin
    describe OcciOpts do

      it "terminates without arguments" do
      	expect{Occi::Bin::OcciOpts.parse [], true}.to raise_error(SystemExit)
      end

      it "terminates when it encounters an unknown argument" do
        expect{Occi::Bin::OcciOpts.parse ["--non-existent", "fake"], true}.to raise_error(SystemExit)
      end

      it "parses minimal number of required arguments without errors" do
        expect{Occi::Bin::OcciOpts.parse ["--resource", "compute", "--action", "list"], true}.not_to raise_error(SystemExit)
      end

      it "parses resource and action arguments without errors" do
        begin
          parsed = Occi::Bin::OcciOpts.parse ["--resource", "compute", "--action", "list"], true
        rescue SystemExit
          fail
        end

        parsed.should_not be_nil

        parsed.resource.should_not be_nil
        parsed.action.should_not be_nil

        parsed.resource.should eq("compute")
        parsed.action.should eq(:list)
      end

      it "shows version"

      it "shows help"

      it "doesn't accept unsupported authN methods"

      it "doesn't accept an invalid URI as an endpoint"

      it "doesn't accept an invalid URI as a resource"

      it "doesn't accept unsupported actions"

      it "doesn't allow create actions without attributes present"

      it "doesn't allow create actions without either link(s) or mixin(s)"

      it "doesn't allow create actions without attribute 'title' present"

      it "doesn't accept malformed mixins"

      it "doesn't accept malformed attributes"

    end
  end
end
