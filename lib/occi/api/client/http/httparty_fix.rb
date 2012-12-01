module HTTParty
  class ConnectionAdapter

    private

    def attach_ssl_certificates(http, options)
      if http.use_ssl?
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        # Client certificate authentication
        if options[:pem]
          http.cert = OpenSSL::X509::Certificate.new(options[:pem])
          http.key = OpenSSL::PKey::RSA.new(options[:pem], options[:pem_password])
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end

        # Set chain of client certificates
        if options[:ssl_proxy_ca]
          http.extra_chain_cert = []

          options[:ssl_proxy_ca].each do |p_ca|
            http.extra_chain_cert << OpenSSL::X509::Certificate.new(p_ca)
          end
        end

        # SSL certificate authority file and/or directory
        if options[:ssl_ca_file]
          http.ca_file = options[:ssl_ca_file]
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end

        if options[:ssl_ca_path]
          http.ca_path = options[:ssl_ca_path]
          http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        end

        # This is only Ruby 1.9+
        if options[:ssl_version] && http.respond_to?(:ssl_version=)
          http.ssl_version = options[:ssl_version]
        end
      end
    end

  end

  module ClassMethods

    def ssl_proxy_ca(array_of_certs)
      default_options[:ssl_proxy_ca] = array_of_certs
    end

  end
end
