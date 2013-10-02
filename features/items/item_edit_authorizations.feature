@seed_policies @seed_stewie_items
Feature: Item Editing
  In order to earn coins
  As a registered user of the website
  I want to manage my items for sale

  # Purchaseable Item
  Scenario: Guest can not edit purchaseable item
    Given I am not logged in
    When I visit the stewie "purchaseable" item "edit" url
    Then I should see authentication required

  Scenario: Registered user can edit own purchaseable item
    Given I am logged in as stewie
    When I visit the stewie "purchaseable" item "edit" url
    Then I should see "Let's modify your listing"

  Scenario: Registered user can not edit other's purchaseable item
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "edit" url
    Then I should see access denied

  # Pending Item
  Scenario: Guest can not edit pending item
    Given I am not logged in
    When I visit the stewie "pending" item "edit" url
    Then I should see authentication required

  Scenario: Registered user can edit own pending item
    Given I am logged in as stewie
    When I visit the stewie "pending" item "edit" url
    Then I should see "Let's modify your listing"

  Scenario: Registered user can not edit other's pending item
    Given I am logged in as ricon
    When I visit the stewie "pending" item "edit" url
    Then I should see access denied
    
  # Disabled Item
  Scenario: Guest can not edit disabled item
    Given I am not logged in
    When I visit the stewie "disabled" item "edit" url
    Then I should see authentication required

  Scenario: Registered user can not edit own disabled item
    Given I am logged in as stewie
    When I visit the stewie "disabled" item "edit" url
    Then I should see access denied

  Scenario: Registered user can not edit other's disabled item
    Given I am logged in as ricon
    When I visit the stewie "disabled" item "edit" url
    Then I should see access denied
  
  # Expired Item
  Scenario: Guest can not edit expired item
    Given I am not logged in
    When I visit the stewie "expired" item "edit" url
    Then I should see authentication required

  Scenario: Registered user can not edit own expired item
    Given I am logged in as stewie
    When I visit the stewie "expired" item "edit" url
    Then I should see access denied

  Scenario: Registered user can not view other's expired item
    Given I am logged in as ricon
    When I visit the stewie "expired" item "edit" url
    Then I should see access denied
