require 'rubygems'
require 'occi'
require 'pp'
require 'hashie/mash'

## options
use_os_temlate = true # use OS_TEMPLATE or NETWORK + STORAGE + INSTANCE TYPE
OS_TEMPLATE = 'monitoring' # name of the VM template in ON

clean_up_compute = true # issue DELETE <RESOURCE> after we are done

USER_CERT           = ENV['HOME'] + '/.globus/usercert.pem'
USER_CERT_PASSWORD = 'mypassphrase'
CA_PATH             = '/etc/grid-security/certificates'

## get an OCCI::Client instance
client = OCCI::Client.new('https://localhost:3300',
                          { :type               => "x509",
                            :user_cert          => USER_CERT,
                            :user_cert_password => USER_CERT_PASSWORD,
                            :ca_path            => CA_PATH })

## get detailed information about all available resources
## then query each resource category in turn
puts "\n\nPrinting all resources"
pp client.get resources

puts "\n\nPrinting storage resources"
pp client.get storage

puts "\n\nPrinting network resources"
pp client.get network

puts "\n\nPrinting compute resources"
pp client.get compute

## get links of all available resources
## then get links for each category in turn
puts "\n\nPrinting locations of all resources"
pp client.list resources

puts "\n\nPrinting locations of storage resources"
pp client.list storage

puts "\n\nPrinting locations of compute resources"
pp client.list compute

puts "\n\nPrinting locations of network resources"
pp client.list network

## get detailed information about available OS templates (== VM templates in ON)
## and resource templates (== INSTANCE TYPES, e.g. small, medium, large etc.)
puts "\n\nPrinting OS templates"
pp client.get_os_templates

puts "\n\nPrinting resource templates"
pp client.get_resource_templates

## create a compute resource using the chosen method
puts "\n\nCreate compute resources"

cmpt = OCCI::Core::Resource.new compute

unless use_os_temlate
  ## without OS template, we have to manually select and attach
  ## network, storage and resource template (instance type)

  ## select instance type medium
  cmpt.mixins << 'http://my.occi.service//occi/infrastructure/resource_tpl#medium'

  ## list network/storage locations and select the appropriate ones (the first ones in this case) 
  puts "\nUsing"
  pp storage_loc = client.list(storage)[0]
  pp network_loc = client.list(network)[0]

  ## create links and attach them to the compure resource
  client.storagelink cmpt, storage_loc
  client.networkinterface cmpt, network_loc
else
  ## with OS template, we have to find the template by name
  ## optionally we can change its "size" by choosing an instance type 
  puts "\nUsing"
  pp os = client.get_os_templates.select { |template| template.term.include? OS_TEMPLATE }
  pp size = client.get_resource_templates.select { |template| template.term.include? 'medium' }
  
  ## attach chosen resources to the compute resource
  cmpt.mixins << os << size
  ## we can change some of the values manually
  cmpt.attributes.occi!.core!.title = "My rOCCI VM"
end

## create the compute resource and print its location
cmpt_loc = client.create cmpt
pp "Location of new compute resource: #{cmpt_loc}"

## get links of all available compute resouces again
puts "\n\nPrinting locations of compute resources (should now contain #{cmpt_loc})"
pp client.list compute

## get detailed information about the new compute resource
## using Hashie simplifies access to its attributes
puts "\n\nPrinting information about compute resource #{cmpt_loc}"
cmpt_data = client.get cmpt_loc.to_s.split('/')[3] + '/' + cmpt_loc.to_s.split('/')[4]
cmpt_hashie = Hashie::Mash.new(JSON.parse(cmpt_data.to_json))

## wait until the resource is "active"
while cmpt_hashie.resources.first.attributes.occi.compute.state == "inactive"
  puts "\nCompute resource #{cmpt_loc} is inactive, waiting ..."
  sleep 1
  cmpt_data = client.get cmpt_loc.to_s.split('/')[3] + '/' + cmpt_loc.to_s.split('/')[4]
  cmpt_hashie = Hashie::Mash.new(JSON.parse(cmpt_data.to_json))
end

puts "\nCompute resource #{cmpt_loc} is #{cmpt_hashie.resources.first.attributes.occi.compute.state}"

## delete the resource and exit
if clean_up_compute
  puts "\n\nDeleting compute resource #{cmpt_loc}"
  pp client.delete cmpt_loc.to_s.split('/')[3] + '/' + cmpt_loc.to_s.split('/')[4]
end
