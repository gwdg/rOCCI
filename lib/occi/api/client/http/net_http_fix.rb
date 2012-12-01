module Net
  class HTTP

    SSL_ATTRIBUTES = SSL_ATTRIBUTES.concat %w(extra_chain_cert)

    # An Array of certificates that will be sent to the client.
    attr_accessor :extra_chain_cert

  end
end
