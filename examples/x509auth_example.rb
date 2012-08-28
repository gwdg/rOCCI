require 'rubygems'
require 'occi'
require 'pp'

## options
use_os_temlate = true # use OS_TEMPLATE or NETWORK + STORAGE + INSTANCE TYPE
OS_TEMPLATE = 'monitoring' # name of the VM template in ON

clean_up_compute = true # issue DELETE <RESOURCE> after we are done

USER_CERT           = ENV['HOME'] + '/.globus/usercert.pem'
USER_CERT_PASSWORD = 'mypassphrase'
CA_PATH             = '/etc/grid-security/certificates'

## get an OCCI::Client instance
client = OCCI::Client.get_client('https://localhost:3300',
                          { :type               => "x509",
                            :user_cert          => USER_CERT,
                            :user_cert_password => USER_CERT_PASSWORD,
                            :ca_path            => CA_PATH })

## get links of all available resources
## then get links for each category in turn
puts "\n\nListing all resources"
client.get_resource_types.each do |type|
  puts "\n\n#{type.capitalize}"
  pp client.list client.get_resource_type_identifier(type)
end

puts "\n\nListing storage resources"
pp client.list client.get_resource_type_identifier("storage")

puts "\n\nListing network resources"
pp client.list client.get_resource_type_identifier("network")

puts "\n\nListing compute resources"
pp client.list client.get_resource_type_identifier("compute")

puts "\n\nListing OS template resources"
pp client.list client.get_resource_type_identifier("os_tpl")

puts "\n\nListing resource template resources"
pp client.list client.get_resource_type_identifier("resource_tpl")

## get detailed information about all available resources
## then query each resource category in turn
puts "\n\nDescribing all resources"
client.get_resource_types.each do |type|
  puts "\n\n#{type.capitalize}"
  pp client.describe client.get_resource_type_identifier(type)
end

puts "\n\nDescribing storage resources"
pp client.describe client.get_resource_type_identifier("storage")

puts "\n\nDescribing compute resources"
pp client.describe client.get_resource_type_identifier("compute")

puts "\n\nDescribing network resources"
pp client.describe client.get_resource_type_identifier("network")

puts "\n\nDescribing OS template resources"
pp client.describe client.get_resource_type_identifier("os_tpl")

puts "\n\nDescribing resource template resources"
pp client.describe client.get_resource_type_identifier("resource_tpl")

=begin
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
  
  puts "\nGetting identifiers"
  pp os_id = os.first.type_identifier
  pp size_id = size.first.type_identifier

  ## attach chosen resources to the compute resource
  cmpt.mixins << os_id << size_id
  ## we can change some of the values manually
  cmpt.attributes.occi!.core!.title = "My rOCCI VM"
end

## create the compute resource and print its location
cmpt_loc = client.create cmpt
pp "Location of new compute resource: #{cmpt_loc}"

## get links of all available compute resouces again
puts "\n\nListing locations of compute resources (should now contain #{cmpt_loc})"
pp client.list compute

## get detailed information about the new compute resource
puts "\n\nListing information about compute resource #{cmpt_loc}"
cmpt_data = client.get cmpt_loc.to_s.split('/')[3] + '/' + cmpt_loc.to_s.split('/')[4]
pp cmpt_data

## wait until the resource is "active"
while cmpt_data.resources.first.attributes.occi.compute.state == "inactive"
  puts "\nCompute resource #{cmpt_loc} is inactive, waiting ..."
  sleep 1
  cmpt_data = client.get cmpt_loc.to_s.split('/')[3] + '/' + cmpt_loc.to_s.split('/')[4]
end

puts "\nCompute resource #{cmpt_loc} is #{cmpt_data.resources.first.attributes.occi.compute.state}"

## delete the resource and exit
if clean_up_compute
  puts "\n\nDeleting compute resource #{cmpt_loc}"
  pp client.delete cmpt_loc.to_s.split('/')[3] + '/' + cmpt_loc.to_s.split('/')[4]
end
=end
