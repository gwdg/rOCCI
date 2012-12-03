##############################################################################
## Net::HTTP hack allowing the use of X.509 proxy certificates.
##############################################################################

# When running Ruby 1.8.x, RUBY_ENGINE is not defined
RUBY_ENGINE = "ruby" unless defined? RUBY_ENGINE

# detect jRuby
if RUBY_ENGINE == 'jruby'
  #TODO: add jRuby support, this doesn't work
  module Net
    class HTTP

      SSL_ATTRIBUTES = SSL_ATTRIBUTES.concat %w(extra_chain_cert)

      # An Array of certificates that will be sent to the client.
      attr_accessor :extra_chain_cert

    end
  end
else
  net_http_fix_rby_ver = RUBY_VERSION.split('.')

  # detect old Rubies, tested with 1.8.7-p371
  if net_http_fix_rby_ver[1] == "8"
    module Net
      class HTTP

        # An Array of certificates that will be sent to the client.
        ssl_context_accessor :extra_chain_cert

      end
    end
  else
    module Net
      class HTTP

        SSL_ATTRIBUTES = SSL_ATTRIBUTES.concat %w(extra_chain_cert)

        # An Array of certificates that will be sent to the client.
        attr_accessor :extra_chain_cert

      end
    end
  end
end
