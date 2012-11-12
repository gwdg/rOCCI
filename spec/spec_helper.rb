if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/cassettes'
end

RSpec.configure do |c|
    c.extend VCR::RSpec::Macros
end

module Occi
  module API

    def self.conn_helper
      #Occi::API::ClientHttp.new('https://localhost:3300',
      #                          { :type  => "none" },
      #                          { :out   => "/dev/null",
      #                            :level => Occi::Log::DEBUG })

      Occi::API::ClientHttp.new("https://carach5.ics.muni.cz:11443",
        { :type               => "x509",
          :user_cert          => ENV['HOME'] + '/.globus/usercred.pem',
          :user_cert_password => "",
          :ca_path            => '/etc/grid-security/certificates' },
        { :out   => STDERR,
          :level => Occi::Log::DEBUG })
    end

  end
end
