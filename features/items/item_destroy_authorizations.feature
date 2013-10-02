@seed_policies @seed_stewie_items
Feature: Item Destruction
  In order to manage my listings
  As a registered user of the website
  I want to remove my unneeded items from the site

  # Purchaseable Item
  Scenario: Guest can not destroy purchaseable item
    Given I am not logged in
    When I delete the stewie "purchaseable" item 
    Then I should see authentication required

  Scenario: Guest can not destroy purchaseable with sales item
    Given I am not logged in
    When I delete the stewie "purchaseable with sales" item 
    Then I should see authentication required

  Scenario: Registered user can destroy own purchaseable item
    Given I am logged in as stewie
    When I delete the stewie "purchaseable" item 
    Then I should see "Your item was removed successfully."

  Scenario: Registered user can not destroy own purchaseable with sales item
    Given I am logged in as stewie
    When I delete the stewie "purchaseable with sales" item 
    Then I should see access denied

  Scenario: Registered user can not destroy other's purchaseable item
    Given I am logged in as ricon
    When I delete the stewie "purchaseable" item 
    Then I should see access denied

  Scenario: Registered user can not destroy other's purchaseable with sales item
    Given I am logged in as ricon
    When I delete the stewie "purchaseable with sales" item 
    Then I should see access denied

  # Pending Item
  Scenario: Guest can not destroy pending item
    Given I am not logged in
    When I delete the stewie "pending" item 
    Then I should see authentication required

  Scenario: Registered user can destroy own pending item
    Given I am logged in as stewie
    When I delete the stewie "pending" item 
    Then I should see "Your item was removed successfully."

  Scenario: Registered user can not destroy other's pending item
    Given I am logged in as ricon
    When I delete the stewie "pending" item 
    Then I should see access denied
    
  # Disabled Item
  Scenario: Guest can not destroy disabled item
    Given I am not logged in
    When I delete the stewie "disabled" item 
    Then I should see authentication required

  Scenario: Registered user can not destroy own disabled item
    Given I am logged in as stewie
    When I delete the stewie "disabled" item 
    Then I should see access denied

  Scenario: Registered user can not destroy other's disabled item
    Given I am logged in as ricon
    When I delete the stewie "disabled" item 
    Then I should see access denied
  
  # Expired Item
  Scenario: Guest can not destroy expired item
    Given I am not logged in
    When I delete the stewie "expired" item 
    Then I should see authentication required

  Scenario: Registered user can not destroy own expired item
    Given I am logged in as stewie
    When I delete the stewie "expired" item 
    Then I should see access denied

  Scenario: Registered user can not destroy other's expired item
    Given I am logged in as ricon
    When I delete the stewie "expired" item 
    Then I should see access denied
