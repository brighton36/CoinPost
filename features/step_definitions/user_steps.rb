### UTILITY METHODS ###

def create_visitor
  @visitor ||= { :name => "Testy McUserton", :email => "example@example.com",
    :password => "please", :password_confirmation => "please" }
end

def find_user
  @user ||= User.first conditions: {:email => @visitor[:email]}
end

def create_unconfirmed_user
  create_visitor
  delete_user
  sign_up
  visit '/sign-out'
end

def create_user
  create_visitor
  delete_user
  @user = FactoryGirl.create(:user, email: @visitor[:email])
end

def delete_user
  @user ||= User.first conditions: {:email => @visitor[:email]}
  @user.destroy unless @user.nil?
end

def sign_up
  delete_user
  visit '/users/sign_up'
  fill_in "user_name", :with => @visitor[:name]
  fill_in "user_email", :with => @visitor[:email]
  fill_in "user_password", :with => @visitor[:password]
  fill_in "user_password_confirmation", :with => @visitor[:password_confirmation]
  click_button "Sign-up"
  find_user
end

def sign_in
  sign_in_as @visitor[:email], @visitor[:password]
end

def sign_in_as(email, password)
  visit '/sign-in'
  fill_in "Email", :with => email
  fill_in "Password", :with => password
  click_button "Sign in"
end

### GIVEN ###
# Just a shortcut that makes our tables easier to write
Given /^I am logged in as guest$/ do
  visit '/sign-out'
end

Given /^I am not logged in$/ do
  visit '/sign-out'
end

Given /^I am logged in$/ do
  create_user
  sign_in
end

Given /^I exist as a user$/ do
  create_user
end

Given /^I do not exist as a user$/ do
  create_visitor
  delete_user
end

Given /^I exist as an unconfirmed user$/ do
  create_unconfirmed_user
end

### WHEN ###
When /^I sign in with valid credentials$/ do
  create_visitor
  sign_in
end

When /^I sign out$/ do
  visit '/sign-out'
end

When /^I sign up with valid user data$/ do
  create_visitor
  sign_up
end

When /^I sign up with an invalid email$/ do
  create_visitor
  @visitor = @visitor.merge(:email => "notanemail")
  sign_up
end

When /^I sign up without a password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "")
  sign_up
end

When /^I sign up without a password$/ do
  create_visitor
  @visitor = @visitor.merge(:password => "")
  sign_up
end

When /^I sign up with a mismatched password confirmation$/ do
  create_visitor
  @visitor = @visitor.merge(:password_confirmation => "please123")
  sign_up
end

When /^I return to the site$/ do
  visit '/'
end

When /^I sign in with a wrong email$/ do
  @visitor = @visitor.merge(:email => "wrong@example.com")
  sign_in
end

When /^I sign in with a wrong password$/ do
  @visitor = @visitor.merge(:password => "wrongpass")
  sign_in
end

When /^I edit my account details$/ do
  click_link "Edit your user profile"
  fill_in "Location", :with => "Wichita Kansas"
  click_button "Update"
end

When /^I look at the list of users$/ do
  visit '/'
end

### THEN ###
Then /^I should be signed in$/ do
  page.should have_content "Sign-out"
  page.should_not have_content "Sign up"
  page.should_not have_content "Sign-in"
end

Then /^I should be signed out$/ do
  page.should have_content "Sign-in or Create Account"
  page.should have_content "Sign-in"
  page.should_not have_content "Sign-out"
end

Then /^I see an unconfirmed account message$/ do
  page.should have_content "You have to confirm your account before continuing."
end

Then /^I see a successful sign in message$/ do
  page.should have_content "Signed in successfully."
end

Then /^I should see a successful sign up message$/ do
  page.should have_content "A message with a confirmation link has been sent to your email address."
end

Then /^I should see an invalid email message$/ do
  page.should have_content "Email is invalid"
end

Then /^I should see a missing password message$/ do
  page.should have_content "Password can't be blank"
end

Then /^I should see a missing password confirmation message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a mismatched password message$/ do
  page.should have_content "Password doesn't match confirmation"
end

Then /^I should see a signed out message$/ do
  page.should have_content "Signed out successfully."
end

Then /^I see an invalid login message$/ do
  page.should have_content "Invalid email or password."
end

Then /^I should see an account edited message$/ do
  page.should have_content "You updated your account successfully."
end

Then /^I should see my name$/ do
  create_user
  page.should have_content @user[:name]
end

When /^I visit the user "([^"]*)" url$/ do |url_label|

  url = {
    'stewie show'  => '/users/stewie-griffen',
  }[url_label]

  visit url
end


# Ajax stuff:
#
def active_modal
  page.all('.modal').to_a.find do |modal|
    /display[ ]*\:[ ]*block/.match modal[:style]
  end
end

def form_by_id(label)
  '#%s' % label.downcase.tr(' ','_')
end

When /^I fill into the "([^"]*)" modal form$/ do |form_label, values|
  within active_modal do
    within( form_by_id(form_label) ) do
      values.rows_hash.each_pair{ |sel, value| fill_in sel, :with => value }
    end
  end
end

When /^I wait until the "([^"]*)" div class is displayed$/ do |divclass|
  page.wait_until do
    found_div = page.find('.%s' % divclass)
    /display[ ]*\:[ ]*block/.match found_div[:style]
  end
end

Given /^The "(.*?)" conversion rate to BTC is "(.*?)"$/ do |iso_code, rate|
  MtgoxBank.ticker_rates ||= Hash.new
  MtgoxBank.ticker_rates[iso_code.downcase] = rate.to_f 
end

When /^I change my conversion currency to "(.*?)"$/ do |iso_code|
  select iso_code, :from => 'user_preffered_currency'
end

When 'I wait for the page to load' do
  wait_until { page.evaluate_script('$.active') == 0 } if Capybara.current_driver == :selenium
  page.has_content? ''
end

Then /^I should see a conversion currency notice of "(.*?)"$/ do |iso_code|
  page.all('#conversion-info .conversion .exchange_rate')[0].text.should eq(iso_code)
end

When /^I login as stewie$/ do
  sign_in_as 'stewiegriffen@spectest.com', 'please'
end

When /^I visit my profile edit page/ do
  visit '/users/edit'
end

When /^I change my profile conversion currency to "(.*?)"$/ do |iso_code|
  select iso_code, :from => 'user_currency'
end

When /^I create a new account via AJAX/ do
  steps %Q{
    When I visit the home page
    And I click "Sign-in or Create Account"
    And I wait until the modal displays
    And I click "Create an Account"
    And I fill into the "Create User" modal form
      | user_name                  | ScottyMctesty |
      | user_email                 | scotty@spectest.com |
      | user_location              | Miami |
      | user_password              | please |
      | user_password_confirmation | please |
    And I click "Create my Account"
    And I wait until the "modal-body_created_user" div class is displayed
  }
end

When /^I confirm the "(.*?)" email address$/ do |email|
  user = User.where(:email => email).first
  user.confirmed_at = Time.now
  user.save!
end

When /^I sign in with email "(.*?)" and password "(.*?)"$/ do |email, password|
  steps %Q{
    When I visit the home page
    And I click "Sign-in or Create Account"
    And I wait until the modal displays
    And I fill into the "User Login Form" modal form
      | session_user_email    | #{email} |
      | session_user_password | #{password} |
    And I click "Sign-in"
  }
end

When /^I create my Shiny Widget for "(.*?)" in user currency$/ do |amnt|
  steps %Q{
    When I visit the main "Sell" link
    And I fill into the "Item" form
      |item_title              | Shiny Widget |
      |item_location           | Miami, FL |
      |item_quantity_listed    | 1 |
      |item_price_in_currency_price  | #{amnt} |
      |item_btc_receive_address| 37muSN5ZrukVTvyVh3mT5Zc5ew9L9CBare |
    And I choose the "price_currency_other" radio button
    And I fill into the tinymce fields
      |item_description | "The <strong>shiniest</strong> widget on the Internet"|
    And I select in the "Item" form
      |item_category_ids       | Collectibles |
      |item_category_ids       | Electronics |
      |item_shipping_policy_id | See Description |
      |item_return_policy_id   | Replacements Only |
    And I click "Next - Add some images"
    And I see "Now let's add some images to this item"
    And I click "Next - Preview Your Item"
    And I see "Verify this item before it goes live?"
    And  I click "Create Item"
    And I see "Your item was created successfully"
  }
end

When /^I visit the shiny widget edit url$/ do
  visit '/items/test-user/shiny-widget/edit'
end
