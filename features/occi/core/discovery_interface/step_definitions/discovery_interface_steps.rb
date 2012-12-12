When /^OCCI Client request all OCCI Categories supported by the OCCI Server$/ do
  if @category_filter.length > 0
    @category_filter   = @category_filter.pluralize
    @selected_category = @client.model.send @category_filter.to_sym
    @selected_category.should have_at_least(1).bla
    pending
  else
    @client.refresh
  end
end

Then /^OCCI Client should display the OCCI Categories received from the OCCI Server$/ do
  @client.model.should_not be_empty

#  @client.model.actions  .should have_at_least(1).actions
  @client.model.kinds    .should have_at_least(4).kinds
  @client.model.links    .should be_empty
  @client.model.resources.should be_empty
end