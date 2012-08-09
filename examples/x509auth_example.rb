require 'rubygems'
require 'occi'
require 'pp'

USER_CERT           = ENV['HOME'] + '/.globus/usercert.pem'
USER_CERT_PASSWORD = 'mypassphrase'
CA_PATH             = '/etc/grid-security/certificates'

client = OCCI::Client.new('https://localhost:3300',
                          { :type               => "x509",
                            :user_cert          => USER_CERT,
                            :user_cert_password => USER_CERT_PASSWORD,
                            :ca_path            => CA_PATH })

puts "\n\nPrinting all resources"
pp client.get resources

puts "\n\nPrinting storage resources"
pp client.get storage

puts "\n\nPrinting network resources"
pp client.get network

puts "\n\nPrinting compute resources"
pp client.get compute

puts "\n\nPrinting locations of all resources"
pp client.list resources

puts "\n\nPrinting locations of storage resources"
pp client.list storage

puts "\n\nPrinting locations of compute resources"
pp client.list compute

puts "\n\nPrinting locations of network resources"
pp client.list network

puts "\n\nPrinting OS templates"
pp client.get_os_templates

puts "\n\nPrinting resource templates"
pp client.get_resource_templates

puts "\n\nCreate compute resources"
cmpt = OCCI::Core::Resource.new compute
cmpt.mixins << 'http://my.occi.service//occi/infrastructure/resource_tpl#medium'

client.storagelink cmpt, client.list(storage)[0]
client.networkinterface cmpt, client.list(network)[0]

cmpt_loc = client.create cmpt
pp "Location of new compute resource: #{cmpt_loc}"
