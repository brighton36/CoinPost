@seed_policies @seed_stewie_items
Feature: Item Relist Authorizations
  In order to make posting easier
  As a registered user of the website
  I want to relist my delisted items for sale

  # Purchaseable Item
  Scenario: Guest can not relist purchaseable item
    Given I am not logged in
    When I visit the stewie "purchaseable" item "relist" url
    Then I should see authentication required

  Scenario: Registered user can not relist own purchaseable item
    Given I am logged in as stewie
    When I visit the stewie "purchaseable" item "relist" url
    Then I should see access denied

  Scenario: Registered user can not relist other's purchaseable item
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "relist" url
    Then I should see access denied
 
  # Pending Item
  Scenario: Guest can not relist pending item
    Given I am not logged in
    When I visit the stewie "pending" item "relist" url
    Then I should see authentication required

  Scenario: Registered user can not relist own pending item
    Given I am logged in as stewie
    When I visit the stewie "pending" item "relist" url
    Then I should see access denied

  Scenario: Registered user can not relist other's pending item
    Given I am logged in as ricon
    When I visit the stewie "pending" item "relist" url
    Then I should see access denied
    
  # Disabled Item
  Scenario: Guest can not relist disabled item
    Given I am not logged in
    When I visit the stewie "disabled" item "relist" url
    Then I should see authentication required

  Scenario: Registered user can relist own disabled item
    Given I am logged in as stewie
    When I visit the stewie "disabled" item "relist" url
    Then I should see "Let's relist this item"

  Scenario: Registered user can not relist other's disabled item
    Given I am logged in as ricon
    When I visit the stewie "disabled" item "relist" url
    Then I should see access denied
  
  # Expired Item
  Scenario: Guest can not relist expired item
    Given I am not logged in
    When I visit the stewie "expired" item "relist" url
    Then I should see authentication required

  Scenario: Registered user can relist own expired item
    Given I am logged in as stewie
    When I visit the stewie "expired" item "relist" url
    Then I should see "Let's relist this item"

  Scenario: Registered user can not view other's expired item
    Given I am logged in as ricon
    When I visit the stewie "expired" item "relist" url
    Then I should see access denied
