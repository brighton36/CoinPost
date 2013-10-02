Feature: Preffered Currency Management
  In order to provide meaningful representations of value to international visitors
  A user
  Should be able to manage their preferred currency

  @javascript
  Scenario: User is not signed up and changes currency
    Given I do not exist as a user
    And The "EUR" conversion rate to BTC is "2.0"
    When I visit the home page
    And I change my conversion currency to "EUR"
    Then I should see a conversion currency notice of "1.0 BTC = €2.00"

  @javascript @seed_stewie_user
  Scenario: Stewie Changes his preffered currency
    Given I am logged in as stewie
    And The "GBP" conversion rate to BTC is "3.0"
    And The "USD" conversion rate to BTC is "10.0"
    When I visit the home page
    And I change my conversion currency to "GBP"
    And I sign out
    And I change my conversion currency to "USD"
    And I login as stewie
    Then I should see a conversion currency notice of "1.0 BTC = £3.00"

  @javascript @seed_stewie_user
  Scenario: Stewie Changes his profile currency via his profile
    Given I am logged in as stewie
    And The "GBP" conversion rate to BTC is "3.0"
    When I visit my profile edit page
    And I change my profile conversion currency to "GBP"
    And I click "Update Profile"
    And I visit the home page
    Then I should see a conversion currency notice of "1.0 BTC = £3.00"
 
  @javascript @seed_item_widget
  Scenario: When a user views an item, its bitcoin value is converted to local currency 
    Given I do not exist as a user
    And The "EUR" conversion rate to BTC is "3.0"
    When I visit the home page
    And I change my conversion currency to "EUR"
    And I visit stewies shiny widget url
    Then I should see "About €24.00 EUR"
 
  @javascript @seed_item_widget
  Scenario: When I create a new account, my preffered currency is set to my profile 
    Given I am not logged in
    And The "CAD" conversion rate to BTC is "4.0"
    When I visit the home page
    And I change my conversion currency to "CAD"
    And I create a new account via AJAX
    And I confirm the "scotty@spectest.com" email address
    And I sign in with email "scotty@spectest.com" and password "please"
    And I visit stewies shiny widget url
    Then I should see "About $32.00 CAD"

  @javascript @seed_categories @seed_policies 
  Scenario: Logged in user posts an item for sale in EUR
    Given I am logged in
    And The "EUR" conversion rate to BTC is "3.0"
    When I visit the home page
    And I change my conversion currency to "EUR"
    And I create my Shiny Widget for "9.00" in user currency
    And I visit the shiny widget url 
    Then I should see "About €9.00 EUR"

  @javascript @seed_categories @seed_policies 
  Scenario: Logged in user posts an item for sale in EUR, changes currency to THB, edits item in EUR
    Given I am logged in
    And The "EUR" conversion rate to BTC is "3.0"
    And The "THB" conversion rate to BTC is "6.0"
    When I visit the home page
    And I change my conversion currency to "EUR"
    And I create my Shiny Widget for "9.00" in user currency
    And I visit the home page
    And I change my conversion currency to "THB"
    And I visit the shiny widget edit url 
    Then I should see "In EUR. Adjusted for exchange rates"
