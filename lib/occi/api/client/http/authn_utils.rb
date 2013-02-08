require 'openssl'

if defined? JRUBY_VERSION
  require 'java'
end

module Occi
  module Api
    module Client

      class AuthnUtils
        # Reads credentials from a PKCS#12 compliant file. Returns
        # X.509 certificate and decrypted private key in PEM
        # formatted string.
        #
        # @example
        #    extract_pem_from_pkcs12 "~/.globus/usercert.p12", "123456"
        #      # => #<String>
        #
        # @param [String] Path to a PKCS#12 file with credentials
        # @param [String] Password needed to unlock the PKCS#12 file
        # @return [String] Decrypted credentials in a PEM formatted string
        def self.extract_pem_from_pkcs12(path_to_p12_file, p12_password)
          # decode certificate and its private key
          pem_from_pkcs12 = ""
          if defined? JRUBY_VERSION
            # Java-based Ruby, read PKCS12 manually
            # using KeyStore
            keystore = Java::JavaSecurity::KeyStore.getInstance("PKCS12")
            p12_input_stream = Java::JavaIo::FileInputStream.new(path_to_p12_file)
            pass_char_array = Java::JavaLang::String.new(p12_password).to_char_array

            # load and unlock PKCS#12 store
            keystore.load p12_input_stream, pass_char_array

            # read the first certificate and PK
            cert = keystore.getCertificate("1")
            pk = keystore.getKey("1", pass_char_array)

            pem_from_pkcs12 << "-----BEGIN CERTIFICATE-----\n"
            pem_from_pkcs12 << Java::JavaxXmlBind::DatatypeConverter.printBase64Binary(cert.getEncoded())
            pem_from_pkcs12 << "\n-----END CERTIFICATE-----"

            pem_from_pkcs12 << "\n"

            pem_from_pkcs12 << "-----BEGIN PRIVATE KEY-----\n"
            pem_from_pkcs12 << Java::JavaxXmlBind::DatatypeConverter.printBase64Binary(pk.getEncoded())
            pem_from_pkcs12 << "\n-----END PRIVATE KEY-----"
          else
            # C-based Ruby, use OpenSSL::PKCS12
            pkcs12 = OpenSSL::PKCS12.new(
              File.open(
                path_to_p12_file,
                'rb'
              ),
              p12_password
            )

            # store cert and private key in a single PEM formatted string
            pem_from_pkcs12 << pkcs12.certificate.to_pem << pkcs12.key.to_pem
          end

          pem_from_pkcs12
        end

        # Reads X.509 certificates from a file to an array.
        #
        # @example
        #    certs_to_file_ary "~/.globus/usercert.pem"
        #      # => [#<String>, #<String>, ...]
        #
        # @param [String] Path to a PEM file containing certificates
        # @return [Array<String>] An array of read certificates
        def self.certs_to_file_ary(ca_file)
          # TODO: read and separate multiple certificates
          [] << File.open(ca_file).read
        end
      end

    end
  end
end
