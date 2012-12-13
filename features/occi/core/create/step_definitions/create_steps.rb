After do |scenario|
  if @uri.lenght > 0
    #delete the created resource
    @client.delete @uri
  end
end

When /^OCCI Client requests OCCI Server to create OCCI Resource with the given kind$/ do
  res = Occi::Core::Resource.new @selected_kind
  @uri = @client.create res
end

When /^get the URI of the created OCCI Resource$/ do
  @uri.should include('/' + @selected_kind.term + '/')
end

When /^the created Resource exist in the OCCI Server$/ do
  description = @client.describe @uri
  collection  = description.first
  collection.resources.should have_exactly(1).resources

  res = description.first.resources.first

  res.kind.term.should == @selected_kind.term
  res.location.should  == (@uri.gsub @endpoint, '/')
end