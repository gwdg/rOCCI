require 'rubygems'
require 'occi'
require 'pp'

pem_path = ENV['HOME'] + '/.globus/usercred.pem'

client = OCCI::Client.new('https://localhost:3300', {:type => "x509", :pem_path => pem_path, :pem_password => "mycertpassword", :ssl_ca_path => "/etc/grid-security/certificates"})

puts "\n\nPrinting all resources"
pp client.get_resources

puts "\n\nPrinting storage resources"
pp client.get_storage_resources

puts "\n\nPrinting network resources"
pp client.get_network_resources

puts "\n\nPrinting compute resources"
pp client.get_compute_resources

puts "\n\nPrinting locations of all resources"
pp client.get_resources_list

puts "\n\nPrinting locations of storage resources"
pp client.get_storage_list

puts "\n\nPrinting locations of compute resources"
pp client.get_compute_list

puts "\n\nPrinting locations of network resources"
pp client.get_network_list
