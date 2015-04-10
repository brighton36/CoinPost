When /^I visit the Need Help\? page$/ do
  visit '/help'
end

When /^I wait until the "([^"]*)" div is displayed$/ do |divclass|
  page.should have_css(form_by_id(divclass), :visible => true)
end
