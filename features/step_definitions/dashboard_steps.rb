When /^I visit the dashboard index$/ do
  visit '/dashboard'
end

When /^I visit the active items dashboard$/ do
  visit '/dashboard/active-items'
end

When /^I visit the pending items dashboard$/ do
  visit '/dashboard/pending-items'
end

When /^I visit the expired items dashboard$/ do
  visit '/dashboard/expired-items'
end

Then /^I should see an "([^"]*)" table with (\d+) rows$/ do |table_id, num_rows|
  page.all( '#%s tbody tr' % table_id ).to_a.length.should eq(num_rows.to_i) 
end
