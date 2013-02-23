require 'rubygems'
require 'occi'
require 'pp'

## options
use_os_temlate = true         # use OS_TEMPLATE or NETWORK + STORAGE + INSTANCE TYPE
OS_TEMPLATE    = 'monitoring' # name of the VM template in ON

clean_up_compute = true       # issue DELETE <RESOURCE> after we are done

USER_CERT          = ENV['HOME'] + '/.globus/usercred.pem'
USER_CERT_PASSWORD = 'mypassphrase'
CA_PATH            = '/etc/grid-security/certificates'
ENDPOINT           = 'https://localhost:3300'

## get an OCCI::Api::Client::ClientHttp instance
client = Occi::Api::Client::ClientHttp.new({
  :endpoint => ENDPOINT,
  :auth => {
    :type               => "x509",
    :user_cert          => USER_CERT,
    :user_cert_password => USER_CERT_PASSWORD,
    :ca_path            => CA_PATH
  },
  :log => {
    :out   => STDERR,
    :level => Occi::Log::DEBUG
  }
})

puts "\n\nListing all available resource types:"
client.get_resource_types.each do |type|
  puts "\n#{type}"
end

puts "\n\nListing all available resource type identifiers:"
client.get_resource_type_identifiers.each do |type_id|
  puts "\n#{type_id}"
end

puts "\n\nListing all available mixin types:"
client.get_mixin_types.each do |mixin_type|
  puts "\n#{mixin_type}"
end

puts "\n\nListing all available mixin type identifiers:"
client.get_mixin_type_identifiers.each do |mixin_typeid|
  puts "\n#{mixin_typeid}"
end

puts "\n\nListing all available mixins:"
client.get_mixins.each do |mixin|
  puts "\n#{mixin}"
end

samples = [OS_TEMPLATE, "medium", "large", "small"]

puts "\n\nFind mixins using their names:"
samples.each do |mixin|
  puts "\n#{mixin}:\n"
  pp client.find_mixin mixin
end

puts "\n\nFind mixins using their names and a type:"
samples.each do |mixin|
  puts "\n#{mixin}:\n"
  pp client.find_mixin(mixin, "os_tpl")
end

puts "\n\nFind mixins using their names and a type:"
samples.each do |mixin|
  puts "\n#{mixin}:\n"
  pp client.find_mixin(mixin, "resource_tpl")
end

puts "\n\nFind mixins using their names (showing detailed descriptions):"
samples.each do |mixin|
  puts "\n#{mixin}:\n"
  pp client.find_mixin(mixin, nil, true)
end

## get links of all available resources
puts "\n\nListing storage resources"
pp client.list "storage"

puts "\n\nListing network resources"
pp client.list "network"

puts "\n\nListing compute resources"
pp client.list "compute"

## get detailed information about all available resources
puts "\n\nDescribing storage resources"
pp client.describe "storage"

puts "\n\nDescribing compute resources"
pp client.describe "compute"

puts "\n\nDescribing network resources"
pp client.describe "network"

## create a compute resource using the chosen method (os_tpl|strg+ntwrk)
puts "\n\nCreate compute resources"
cmpt = client.get_resource "compute"

unless use_os_temlate
  ## without OS template, we have to manually select and attach
  ## network, storage and resource template (instance type)

  ## select instance type medium
  cmpt.mixins << client.find_mixin('medium', "resource_tpl")

  ## list network/storage locations and select the appropriate ones (the first ones in this case)
  puts "\nUsing:"
  pp storage_loc = client.list("storage")[0]
  pp network_loc = client.list("network")[0]

  ## create links and attach them to the compure resource
  puts "\n Connecting to our compute:"
  cmpt.storagelink storage_loc
  cmpt.networkinterface network_loc
else
  ## with OS template, we have to find the template by name
  ## optionally we can change its "size" by choosing an instance type
  puts "\nUsing:"
  pp os = client.find_mixin(OS_TEMPLATE, "os_tpl")
  pp size = client.find_mixin('medium', "resource_tpl")

  ## attach chosen resources to the compute resource
  cmpt.mixins << os << size
  ## we can change some of the values manually
  cmpt.title = "My rOCCI x509 VM"
end

## create the compute resource and print its location
cmpt_loc = client.create cmpt
pp "Location of new compute resource: #{cmpt_loc}"

## get links of all available compute resouces again
puts "\n\nListing locations of compute resources (should now contain #{cmpt_loc})"
pp client.list "compute"

## get detailed information about the new compute resource
puts "\n\nListing information about compute resource #{cmpt_loc}"
cmpt_data = client.describe cmpt_loc
pp cmpt_data

## wait until the resource is "active"
while cmpt_data[0].resources.first.attributes.occi.compute.state == "inactive"
  puts "\nCompute resource #{cmpt_loc} is inactive, waiting ..."
  sleep 1
  cmpt_data = client.describe cmpt_loc
end

puts "\nCompute resource #{cmpt_loc} is #{cmpt_data[0].resources.first.attributes.occi.compute.state}"

## delete the resource and exit
if clean_up_compute
  puts "\n\nDeleting compute resource #{cmpt_loc}"
  pp client.delete cmpt_loc
end
