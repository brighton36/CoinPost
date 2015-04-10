def form_by_class(form_name)
  'form.%s' % form_name.downcase.tr(' ','_')
end

When /^I visit the main "([^"]*)" link$/ do |nav_link|
  within(".navbar") do
    visit '/'
    click_link nav_link
  end
end

When /^I fill into the "([^"]*)" form$/ do |form_name, values|
  within( form_by_class(form_name) ) do
    values.rows_hash.each_pair do |locator, value|
      fill_in locator, :with => value
    end
  end
end

When /^I select in the "([^"]*)" form$/ do |form_name, values|
  within( form_by_class(form_name) ) do
    values.rows_hash.each_pair do |locator, value|
      select value, :from => locator
    end
  end
end

When /^I fill into the tinymce fields$/ do |table|
  table.rows_hash.each_pair do |selector, value|
    page.execute_script( 
      'tinyMCE.get(%s).setContent(%s);' % [selector,value].collect(&:to_json)
    )
  end
end

When /^I attach the image "([^"]*)" to "([^"]*)"$/ do |src, selector|
  attach_file selector, Rails::root.join('spec','assets', src)

  # NOTE : For some reason on OSX, this takes a little while for the auto-upload
  # to kick-in. This hackish fix allows the test to complete
  sleep 1
end

When /^I click "([^"]*)"$/ do |link_or_button|
  page.click_link_or_button link_or_button
end

When /^I fill in a new item form$/ do
  steps( %Q(
    When I fill into the "Item" form
      |item_title              | Shiny Widget |
      |item_location           | Miami, FL |
      |item_quantity_listed    | 1 |
      |item_price_in_btc       | 5.00000001 |
      |item_btc_receive_address| 37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare |
    And I fill into the tinymce fields
      |item_description | "The <strong>shiniest</strong> widget on the Internet"|
    And I select in the "Item" form
      |item_category_ids       | Collectibles |
      |item_category_ids       | Electronics |
      |item_shipping_policy_id | See Description |
      |item_return_policy_id   | Replacements Only |
  ) )
end


When /^wait for the upload to finish$/ do
  page.should have_selector '#fileupload table tbody.files tr.template-download'
end

When /^I see "([^"]*)"$/ do |msg|
  steps 'Then I should see "%s"' % msg
end

Then /^I should see "([^"]*)"$/ do |msg|
  page.instance_eval{@touched=false}
  page.should have_content(msg)
end

Then /^I should see an image labeled "([^"]*)"$/ do |alt|
  page.has_css?( 'img[alt="%s"]' % [alt] ).should be_true
end

Then /^I should not see an image labeled "([^"]*)"$/ do |alt|
  page.has_css?( 'img[alt="%s"]' % [alt] ).should be_false  
end

Then /^I should see an download row labeled "([^"]*)"$/ do |label|
  page.has_css?( 'table tr td.name a[title="%s"]' % [label] ).should be_true
end

When /^I visit the widget item url$/ do
  visit '/items/shiny-widget'
end

Given /^I am logged in as stewie$/ do
  sign_in_as 'stewiegriffen@spectest.com', 'please'
end

Given /^I am logged in as ricon$/ do
  sign_in_as 'rickonstark@spectest.com', 'please'
end

Given /^I am logged in as oldnan$/ do
  sign_in_as 'oldnan@spectest.com', 'please'
end

Then /^the "([^"]*)" field should contain "([^"]*)"$/ do |field_selector, should_val|
  find_field(field_selector).value.should eq(should_val)
end

Then /^I should see access denied$/ do
  page.should have_content('You are not authorized to access the requested resource.')
end

Then /^I should see authentication required$/ do
  page.should have_content('You need to sign in or sign up before continuing.')
end

def stewie_item_slugs(label)
  'stewie-griffen/%s' % {
  'purchaseable' => 'stewie-s-shiny-widget',
  'purchaseable with sales' => 'stewie-s-shiny-widget-with-sales',
  'sold out'     => 'stewie-s-sold-out-widget',
  'pending'      => 'stewie-s-pending-shiny-widget',
  'disabled'     => 'stewie-s-disabled-shiny-widget',
  'expired'      => 'stewie-s-expired-shiny-widget',
  'reposted expired' => 'stewie-s-expired-shiny-widget--2'
  }[label]
end

When /^I visit the stewie "([^"]*)" item "([^"]*)" url$/ do |label, action|
  url_action = { 'show' => nil, 'edit' => 'edit', 'destroy' => 'delete', 
    'disable' => 'disable', 'edit-images' => 'edit-images', 'relist' => 'relist'
  }[action]

  visit [ '/items', stewie_item_slugs(label), url_action ].join('/')
end

When /^I delete the stewie "([^"]*)" item$/ do |item|
  steps 'When I visit the stewie "%s" item "destroy" url' % [item]
end

When /^I delist the stewie "([^"]*)" item$/ do |item|
  page.driver.post ['/items', stewie_item_slugs(item), 'disable'].join('/')
  page.visit page.driver.response.original_headers['Location']
end

When /^I visit the stewie purchaseable 2\.0 url$/ do 
  visit "/items/stewie-griffen/stewie-s-shiny-widget-2-0"
end


When /^I change the title of the stewie purchaseable item$/ do
  steps( %Q(
    When I visit the stewie "purchaseable" item "edit" url
    And I fill into the "Item" form
      |item_title              | Stewie's Shiny Widget 2.0 |
    And I click "Update"
  ) )
end

When /^I add an image to the stewie purchaseable item$/ do
  steps( %Q(
    When I visit the stewie "purchaseable" item "edit-images" url
    And I attach the image "rambo-tux.png" to "item_image[image]"
    And wait for the upload to finish
    And I click "Update Item"
  ) )
end

When /^I delete the item image "([^"]*)"$/ do |label|
  image_row = page.all( 'tbody.files tr' ).to_a.find{ |r| 
    r.find('td.name a[title="%s"]' % [label] )
  }
  image_row.click_button 'Delete'
end

When /^I start a new item and get to the add images step$/ do
  steps( %Q(
    When I visit the main "Sell" link
    And I fill in a new item form
    And I click "Next - Add some images"
    And I see "Now let's add some images to this item"
  ) )
end

When /^I visit the shiny widget url$/ do 
  visit '/items/test-user/shiny-widget'
end

When /^I visit stewies shiny widget url$/ do 
  visit '/items/stewie-griffen/shiny-widget'
end

Then /^I should see in the "([^"]*)" select field$/ do |selector, value_labels|
  field = find_field(selector)

  field_map = field.all('option').inject({}) do |ret, opt|
    ret.merge({opt.value => opt.text})
  end

  value_labels.raw.flatten.sort.should eq( 
    field.value.collect{|v| field_map[v]}.sort 
  )
end

When /^I choose the "([^"]*)" radio button$/ do |but_id|
  choose but_id
end

Given /^the BTC to USD exchange rate is (\d+)$/ do |btc_rate|
  MtgoxBank.ticker_rates = {'usd' => btc_rate.to_f}
end

When /^I post "(.*?)" to the reddit submit url$/ do |item|
  item_id = {'Newly posted item' => 'stewie-s-shiny-widget',
  'Already posted item' => 'stewie-s-shiny-widget-on-reddit',
  'Not yet listed item' => 'stewie-s-pending-shiny-widget'
  }[item]
  page.driver.header 'Accept', 'text/javascript, application/javascript'
  page.driver.post('/items/stewie-griffen/%s/submit-to-reddit' % item_id, 
    'reddit' => {:username => 'testuser', :password => nil})
end

Then /^I should expect a "(.*?)" http response$/ do |label|
  code = {'Missing password' => 422, 'Denied' => 401}[label]
  page.driver.status_code.should eq(code)
end
