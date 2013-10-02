@seed_policies @seed_stewie_items @javascript
Feature: Item Editing
  In order to update my item listings
  As a registered user of the website
  I want to edit my items for sale

  Scenario: User can edit their item
    Given I am logged in as stewie
    When I visit the stewie "purchaseable" item "edit" url
    Then the "item_title" field should contain "Stewie's Shiny Widget"

  Scenario: User can commit change to their item
    Given I am logged in as stewie
    When I change the title of the stewie purchaseable item
    Then I should see "Your item was updated successfully."
  
  Scenario: User can view the changes made to their item
    Given I am logged in as stewie
    When I change the title of the stewie purchaseable item
    And I visit the stewie purchaseable 2.0 url
    Then I should see "Stewie's Shiny Widget 2.0" 
  
  Scenario: User is prompted to fix changes when item is invalid
    Given I am logged in as stewie
    When I visit the stewie "purchaseable" item "edit" url
    And I fill into the "Item" form
      |item_title              | |
    And I click "Update Item"
    Then I should see "There was a problem with your changes" 

  Scenario: User edits their item to add an image
    Given I am logged in as stewie
    When I add an image to the stewie purchaseable item
    Then I should see "Your item was updated successfully"

  Scenario: User edits their item to add an image and sees the change reflected
    Given I am logged in as stewie
    When I add an image to the stewie purchaseable item
    And I visit the stewie "purchaseable" item "show" url
    Then I should see an image labeled "rambo-tux.png"

  @seed_stewie_item_images
  Scenario: User edits their item to delete an image and sees the change reflected
    Given I am logged in as stewie
    When I visit the stewie "purchaseable" item "edit-images" url
    And I delete the item image "ubuntu-logo.png"
    And I click "Update Item"  
    And I visit the stewie "purchaseable" item "show" url
    Then I should not see an image labeled "ubuntu-logo.png"

  Scenario: User changes item cost from BTC price to USD price
    Given I am logged in as stewie
    And the BTC to USD exchange rate is 2
    When I visit the stewie "purchaseable" item "edit" url
    And I fill into the "Item" form
      |item_price_in_currency_price       |  10.00 |
      |item_title              | Stewie's Shiny Widget 2.0 |
    And I choose the "price_currency_other" radio button
    And I click "Update Item"
    And I see "Your item was updated successfully"
    And I visit the stewie purchaseable 2.0 url
    Then I should see "About $10.00 USD"
