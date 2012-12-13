Given /^endpoint : (.*)$/ do |endpoint|
  @endpoint = endpoint
  @endpoint =~ URI::ABS_URI
  @endpoint.should_not be_nil
end

Given /^transfer_protocol : (http|amqp)$/ do |protocol|
  @transfer_protocol = protocol
end

Given /^accept type : (text\/occi|text\/plain|application\/json)$/ do |accept_type|
  @accept_type = accept_type
end

Given /^category filter : (.*)$/ do |category_filter|
  @category_filter = category_filter
end

Given /^have an initialize Client$/ do
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

When /^OCCI Kind (.*) is selected$/ do |occi_kind_identifier|
  @selected_kind = @client.model.kinds.select{ |kind| kind.type_identifier == occi_kind_identifier}.first
  @selected_kind.should_not be_nil
end