##############################################################################
## Net::HTTP hack allowing the use of X.509 proxy certificates.
##############################################################################

module Net
  class HTTP

    if defined? SSL_ATTRIBUTES
      # For Rubies 1.9.x
      old_verbose, $VERBOSE = $VERBOSE, nil
      SSL_ATTRIBUTES = SSL_ATTRIBUTES.concat %w(extra_chain_cert)
      $VERBOSE = old_verbose

      attr_accessor :extra_chain_cert
    else
      # For legacy Rubies 1.8.x
      ssl_context_accessor :extra_chain_cert
    end

  end
end
