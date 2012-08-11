require 'rubygems'
require 'occi'
require 'pp'

use_os_temlate = false # true
OS_TEMPLATE = 'monitoring' # name of the VM template in ON

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

unless use_os_temlate
  cmpt.mixins << 'http://my.occi.service//occi/infrastructure/resource_tpl#medium'

  puts "\nUsing"
  pp storage_loc = client.list(storage)[0]
  pp network_loc = client.list(network)[0]

  client.storagelink cmpt, storage_loc
  client.networkinterface cmpt, network_loc
else
  puts "\nUsing"
  pp os = client.get_os_templates.select { |template| template.term.include? OS_TEMPLATE }
  pp size = client.get_resource_templates.select { |template| template.term.include? 'medium' }
  
  cmpt.mixins << os << size
  cmpt.attributes.occi!.core!.title = "My rOCCI VM"
end

cmpt_loc = client.create cmpt
pp "Location of new compute resource: #{cmpt_loc}"
