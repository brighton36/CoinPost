@seed_policies @seed_stewie_items
Feature: Item Image Creation
  In order to make my item posts convert better
  As a registered user of the website
  I want to create images of my items for sale

  # New Item
  Scenario: Guest can not add images to new item
    Given I am not logged in
    When I upload an image to a new item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can add images to new item
    Given I am logged in as stewie
    When I upload an image to a new item
    Then I should receive a "sucessful" status code

  # Purchaseable Item
  Scenario: Guest can not add images to purchaseable item
    Given I am not logged in
    When I upload an image to a new item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can add images to own purchaseable item
    Given I am logged in as stewie
    When I upload an image to the stewie "purchaseable" item
    Then I should receive a "sucessful" status code

  Scenario: Registered user can not add images to other's purchaseable item
    Given I am logged in as ricon
    When I upload an image to the stewie "purchaseable" item
    Then I should receive a "unauthorized" status code

  # Pending Item
  Scenario: Guest can not add images to pending item
    Given I am not logged in
    When I upload an image to the stewie "pending" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can add images to own pending item
    Given I am logged in as stewie
    When I upload an image to the stewie "pending" item
    Then I should receive a "sucessful" status code

  Scenario: Registered user can not add images to other's pending item
    Given I am logged in as ricon
    When I upload an image to the stewie "pending" item
    Then I should receive a "unauthorized" status code
    
  # Disabled Item
  Scenario: Guest can not add images to disabled item
    Given I am not logged in
    When I upload an image to the stewie "disabled" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not add images own disabled item
    Given I am logged in as stewie
    When I upload an image to the stewie "disabled" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not add images other's disabled item
    Given I am logged in as ricon
    When I upload an image to the stewie "disabled" item
    Then I should receive a "unauthorized" status code
  
  # Expired Item
  Scenario: Guest can not add images to expired item
    Given I am not logged in
    When I upload an image to the stewie "expired" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not add images to own expired item
    Given I am logged in as stewie
    When I upload an image to the stewie "expired" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not add images to other's expired item
    Given I am logged in as ricon
    When I upload an image to the stewie "expired" item
    Then I should receive a "unauthorized" status code
