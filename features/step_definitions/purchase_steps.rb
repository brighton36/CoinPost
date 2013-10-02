When /^I post "([^"]*)" to the stewie create purchase url$/ do |item_label|
  page.driver.header 'Accept', 'application/json, text/javascript;'
  page.driver.post(
    '/items/%s/purchase' % stewie_item_slugs(item_label),
    'purchase[quantity_purchased]' => '1'
  )
end

def purchase_url(label)
  { 
    'stewie fulfilled'   => '/users/stewie-griffen/sales',
    'stewie unfulfilled' => '/users/stewie-griffen/sales/unfulfilled',
    'stewie paid'        => '/users/stewie-griffen/purchases',
    'stewie unpaid'      => '/users/stewie-griffen/purchases/unpaid',
    'ricon fulfilled'    => '/users/rickon-stark/sales',
    'ricon unfulfilled'  => '/users/rickon-stark/sales/unfulfilled',
    'ricon paid'         => '/users/rickon-stark/purchases',
    'ricon unpaid'       => '/users/rickon-stark/purchases/unpaid',
    'ricon mark paid'    => '/users/rickon-stark/mark-paid/',
    'stewie mark fulfilled' => '/users/stewie-griffen/mark-fulfilled/',
    'stewie needing feedback' => '/users/stewie-griffen/leave-feedback'
  }[label]
end

def purchase_id(label)
  case label
    when "ricon's unpaid unfulfilled" then @purchases[:ricons_purchase_item_sent_no_payment].id
    when "ricon's fulfilled" then @purchases[:ricons_purchase_item_sent].id
    when "ricon's paid" then @purchases[:ricons_purchase_payment_sent].id
    when "ricon's unpaid" then @purchases[:ricons_purchase].id
  end
end

def purchase_from_label(label)
  @purchases[label.tr(' ','_').to_sym]
end

When /^I visit the "([^"]*)" purchase url$/ do |label|
  visit purchase_url(label)
end

When /^I post "([^"]*)" to the "([^"]*)" leave feedback as a "([^"]*)"$/ do |purchase_label, user_label, relationship|
  user_part = (user_label == 'stewie') ? 'stewie-griffen' : 'rickon-stark'
  page.driver.put(
    '/users/%s/leave-feedback/%s' % [
      (user_label == 'stewie') ? 'stewie-griffen' : 'rickon-stark',
      purchase_from_label(purchase_label).id 
    ],
    Hash[{:comment => 'comment', :rating => 1}.collect{|f,v| 
      [ 'purchase[%s_on_%s]' % [f, relationship], v] 
    }]
  )
end

When /^I click the "([^"]*)" payment row's "([^"]*)"$/ do |item_label, button_label|
  row = page.all( '.payment_listing_table tbody tr' ).to_a.find do |row|
    row.find('td:first a').try(:text).try(:strip) == item_label
  end

  row.all('a').to_a.find{|a| a.text.strip == button_label }.click
end

When /^I wait until the modal displays$/ do
  # This ensure's that we wait until the window is visible before continuing.
  # Otherwise we end up with an odd timing bug on OS X
  page.wait_until do
    page.all('.modal').to_a.find do |modal|
      /display[ ]*\:[ ]*block/.match modal[:style]
    end
  end
end

When /^I request javascript responses$/ do
  page.driver.header 'Accept', 'application/json, text/javascript;'
end

When /^I post "([^"]*)" to the "([^"]*)" purchase url$/ do |purchase_label, url_label|
  page.driver.post [
    purchase_url(url_label), purchase_id(purchase_label)
  ].join('/')
end

When /^I click the active modal window's "([^"]*)"$/ do |button_label|
  modal = page.all('.modal').to_a.find do |modal|
    /display[ ]*\:[ ]*block/.match modal[:style]
  end

  modal.all("a, input[type='submit'], button").to_a.find{|a| 
    a.text.strip == button_label || a[:value] == button_label 
  }.try(:click)
end

Then /^I should see (\d+) "([^"]*)" feedback forms$/ do |count, container|
  page.all('.%s_feedback form' % container).count.should eq(count.to_i)
end

def feedback_form(container)
  '.%s_feedback .leave_feedback' % [container.downcase] 
end

def within_feedback_form(container)
  within( feedback_form(container) ) do
    yield
  end
end

When /^I fill into the first "([^"]*)" feedback form$/ do |container, fields|
  within_feedback_form(container) do
    fields.rows_hash.each_pair do |locator, value|
      fill_in locator, :with => value
    end
  end
end

When /^I click "([^"]*)" on the first "([^"]*)" feedback form$/ do |selector, container|
  within_feedback_form(container) { page.find('#%s' % selector).click }
end

When /^I click the "([^"]*)" button on the first "([^"]*)" feedback form$/ do |selector, container|
  within_feedback_form(container) { click_link_or_button selector }
end

When /^I wait for the loading indicator to finish on the first "([^"]*)" feedback form$/ do |container|
  within_feedback_form(container) do
    page.wait_until do
      loading = page.find('.loading_indicator')
      /display[ ]*\:[ ]*none/.match loading[:style] 
    end
  end
end

Then /^I should see the first "([^"]*)" feedback form disappear$/ do |container|
  within_feedback_form(container) do
    page.find('.feedback_row')[:style].should match(/display[ ]*\:[ ]*none/)
  end
end

Then /^I should not see the first "([^"]*)" feedback form disappear$/ do |container|
  within_feedback_form(container) do
    page.find('.feedback_row')[:style].should_not match(/display[ ]*\:[ ]*none/)
  end
end

Then /^I should see a modal purchase total of "([^"]*)"$/ do |total|
  modal = page.all('.modal').to_a.find do |modal|
    /display[ ]*\:[ ]*block/.match modal[:style]
  end

  modal.find('.modal-body_success .btc_money .amount').text.should eq(total)
end
