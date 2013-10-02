Then /^I should see items for sale$/ do
  page.should have_selector('#category_listing_table tbody tr')
end

When /^I visit the home page$/ do
  visit '/'
end

When /^I click the "([^"]*)" category link$/ do |label|
  link = all("#categories_block a").to_a.find{ |a| /\A#{label}/.match a.text }
  link.click 
end
