When /^I visit the Need Help\? page$/ do
  visit '/help'
end

When /^I wait until the "([^"]*)" div is displayed$/ do |divclass|
  page.wait_until do
    found_div = page.find form_by_id(divclass)
    /display[ ]*\:[ ]*block/.match found_div[:style]
  end
end
