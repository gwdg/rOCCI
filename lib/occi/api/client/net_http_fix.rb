module Net
  class HTTP

     SSL_IVNAMES = [
      :@ca_file,
      :@ca_path,
      :@cert,
      :@cert_store,
      :@ciphers,
      :@key,
      :@ssl_timeout,
      :@ssl_version,
      :@verify_callback,
      :@verify_depth,
      :@verify_mode,
      :@client_ca,
    ]

    SSL_ATTRIBUTES = [
      :ca_file,
      :ca_path,
      :cert,
      :cert_store,
      :ciphers,
      :key,
      :ssl_timeout,
      :ssl_version,
      :verify_callback,
      :verify_depth,
      :verify_mode,
      :client_ca,
    ]

    # A certificate or Array of certificates that will be sent to the client.
    attr_accessor :client_ca

  end
end
