When /^I visit the messages "([^"]*)" url$/ do |url_label|
  stewie = User.where(:email => 'stewiegriffen@spectest.com')
  @stewie_msg_one = stewie.first.mailbox.conversations.to_a.find{|conv|
    conv.subject == 'Message To Stewie One' }.try(:messages).try(:first)

  urls = {
    'view stewie inbox'  => '/users/stewie-griffen/inbox',
    'view ricon inbox'   => '/users/rickon-stark/inbox',
    'view stewie sent'   => '/users/stewie-griffen/sent-messages',
    'view stewie trash'  => '/users/stewie-griffen/trashed-messages'
  }

  urls.merge!({
    'show stewie message'=> [
      '/users/stewie-griffen/messages', @stewie_msg_one.id].join('/') ,
    'reply stewie message' => [
      '/users/stewie-griffen/messages', @stewie_msg_one.id, 'reply'].join('/') 
  }) if @stewie_msg_one

  visit urls[url_label]
end

Then /^I should see (\d+) messages in my messages table$/ do |num_rows|
  page.all( '.message_listing_table tbody tr' ).to_a.length.should eq(num_rows.to_i) 
end

def find_message_row(subject)
  page.all( '.message_listing_table tbody tr' ).to_a.find do |row|
    true if row.find('td.subject_column').text.strip == subject
  end

  rescue Capybara::ElementNotFound
end

Then /^I should see that message "([^"]*)" is read$/ do |subject|
  find_message_row(subject)[:class].should be_empty
end

Then /^I should see that message "([^"]*)" is unread$/ do |subject|
  find_message_row(subject).try(:[], :class).should eq("unread")
end

When /^I select the "([^"]*)" message$/ do |subject|
  find_message_row(subject).try :check, 'message_ids[]'
end

Then /^I should see the message "([^"]*)"$/ do |subject|
  find_message_row(subject).should_not be_nil
end

When /^I wait for the "([^"]*)" loading indicator to finish$/ do |form|
  modal_sel = '#%s .loading_indicator' % form.downcase.tr(' ','_')
  page.should have_selector(modal_sel, :visible => false)
end

Then /^I should see the modal popup success message$/ do
  page.find('.modal-body_success')[:style].should match(/display[ ]*\:[ ]*block/)
end

Then /^I should not see the modal popup success message$/ do
  page.should have_selector('.modal-body_success', :visible => false)
end

Then /^I should receive a "([^"]*)" html response$/ do |response|
  steps case response
    when 'Login'
      'Then I should see authentication required'
    when 'Denied'
      'Then I should see access denied'
    else
      'Then I should see "%s"' % response
  end
end

When /^I post to the create message to stewie url$/ do
  page.driver.header 'Accept', 'application/json, text/javascript;'
  page.driver.post(
    '/users/stewie-griffen/messages', 
    'message[subject]' => 'Hey ya stew',
    'message[body]' => 'Hows it going'
  )
end

Then /^I should receive a "([^"]*)" http response code$/ do |label|
  code = {'Success' => 200, 'Unauthorized' => 401, 'Unprocessable' => 422}[label]
  page.driver.status_code.should eq(code)
end

def message_from_label(label, source)
  @stewie.send('messages_in_%s' % source).where(:subject => label).first
end

def message_trashing(page, action, message)
  page.driver.post '/users/stewie-griffen/%s-messages' % action, 
    'message_ids[]' => message_from_label(
      message, (action == 'trash') ? 'inbox' : 'trash').id
end

When /^I post "([^"]*)" to the trash stewie messages url$/ do |label|
  message_trashing page, 'trash', label
end

When /^I post "([^"]*)" to the untrash stewie messages url$/ do |label|
  message_trashing page, 'untrash', label
end

Then /^I should expect a "([^"]*)" http redirect location$/ do |url|   
  if /\Ahttp\:\/\/[^\/]+\/(.+)/.match page.driver.response.original_headers['Location']
    $1.should eq(url)
  else
    url.should eq('Denied')
  end
end

When /^I post "([^"]*)" to the create reply stewie message url$/ do |label|
  msg = message_from_label(label, 'inbox')
  page.driver.post(
    '/users/stewie-griffen/messages/%s/reply' % msg.id, 
    'message[subject]' => 'RE: Hey ya stew',
    'message[body]' => 'Its going well'
  )
end

When /^I post "([^"]*)" to the stewie create item question url$/ do |label|
  item = stewie_item_slugs label

  page.driver.header 'Accept', 'application/json, text/javascript;'
  page.driver.post(
    '/items/%s/ask-question' % item, 
    'message[body]' => 'I wish you had this in blue'
  )
end


When /^I ask stewie a question about his purchaseable item$/ do
  steps( %Q(
    When I visit the stewie "purchaseable" item "show" url
    And I click "Ask the seller a question"
    And I fill into the tinymce fields
      |message_body | "Answer my <strong>damn</strong> question"|
    And I click "Ask Question"
    And I wait for the "Ask Seller a Question" loading indicator to finish
  ) )
end

When /^I contact stewie through his user detail page$/ do
  steps( %Q(
    When I visit the user "stewie show" url
    And I click "Send me a message"
    And I fill into the "Message Create" form
      | message_subject | Are you available?... |
    And I fill into the tinymce fields
      |message_body | "Answer my <strong>damn</strong> question"|
    And I click "Send Message"
    And I wait for the "Send User Message" loading indicator to finish
  ) )
end


When /^Stewie replys to Message To Stewie One$/ do
  steps( %Q(
    When I visit the messages "show stewie message" url
    And I click "Send a reply"
    And I fill into the "Message" form
      | message_subject | RE: Will you ship to Alaska? |
      | message_body | Your sister is a penguin?    |
    And I click "Send your reply"
  ) )
end
