Given /^I use endpoint (.*)$/ do |endpoint|
  @endpoint = endpoint
  @endpoint =~ URI::ABS_URI
  @endpoint.should_not be_nil
end

Given /^as protocol (http|amqp)$/ do |protocol|
  @transfer_protocol = protocol
end

Given /^the clients accept type is (text\/occi|text\/plain|application\/json)$/ do |accept_type|
  @accept_type = accept_type
end

When /^OCCI Client request all OCCI Categories supported by the OCCI Server$/ do
  require 'occi'

  @client = Occi::Api::Client::ClientHttp.new(
      @endpoint, #141.5.99.69 #11.5.99.82
      { :type  => "none" },
      { :out   => "/dev/null",
        :level => Occi::Log::DEBUG },
      true,
      @accept_type#"text/plain,text/occi"
  )
end

Then /^the Client should have the response code (.*)$/ do |response_code|
  @client.last_response.code.should == response_code.to_i
end

Then /^OCCI Client should display the OCCI Categories received from the OCCI Server$/ do
  @client.model.should_not be_empty

#  @client.model.actions  .should have_at_least(1).actions
  @client.model.kinds    .should have_at_least(4).kinds
  @client.model.links    .should be_empty
  @client.model.resources.should be_empty
end

#Given /^select "([^"]*)" Category from the OCCI Server$/ do |category|
#  category = category.pluralize
#  @selected_category = @client.model.send category.to_sym
#  @selected_category.should have_at_least(1).bla
#end