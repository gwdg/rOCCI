require 'rspec'
require 'occi/api/client/http/authn_utils'

module Occi
  module Api
    module Client

      describe AuthnUtils do

        it "can handle PKCS#12 user credentials" do
          path = File.expand_path("..", __FILE__)

          pem_cert_pk = AuthnUtils.extract_pem_from_pkcs12(
            path + "/rocci-cred.p12",
            "passworD123"
          )

          pem_cert_ok = File.open(path + "/rocci-cred-cert.pem", "rb").read

          if defined? JRUBY_VERSION
            # PK is in PKCS#8 when running jRuby
            pem_pk_ok = File.open(path + "/rocci-cred-key-jruby.pem", "rb").read
          else
            # PK is raw RSA key when running cRuby
            pem_pk_ok = File.open(path + "/rocci-cred-key.pem", "rb").read
          end

          pem_cert_pk_ok = ""
          pem_cert_pk_ok << pem_cert_ok << pem_pk_ok


          # remove line wrapping
          pem_cert_pk.delete! "\n"
          pem_cert_pk_ok.delete! "\n"

          # remove trailing new lines
          pem_cert_pk.chomp!
          pem_cert_pk_ok.chomp!

          pem_cert_pk.should eq pem_cert_pk_ok
        end

        it "can read CA certificates from a file" do
          path = File.expand_path("..", __FILE__)

          ca_certs = AuthnUtils.certs_to_file_ary(path + "/rocci-cred-cert.pem")

          ca_certs.should =~ [File.open(path + "/rocci-cred-cert.pem", "rb").read]
        end

      end

    end
  end
end
