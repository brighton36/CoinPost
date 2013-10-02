@seed_policies @seed_stewie_items @seed_stewie_item_images
Feature: Item Image Removal
  In order to make my item posts convert better
  As a registered user of the website
  I want to delete images of my items for sale

  # New Item
  Scenario: Guest can not remove images from new item
    Given I am not logged in
    When I remove an image from a new item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can remove images from new item
    Given I am logged in as stewie
    When I remove an image from a new item
    Then I should receive a "delete sucessful" status code

  # Purchaseable Item
  Scenario: Guest can not remove images from purchaseable item
    Given I am not logged in
    When I remove an image from the stewie "purchaseable" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can remove images from own purchaseable item
    Given I am logged in as stewie
    When I remove an image from the stewie "purchaseable" item
    Then I should receive a "delete sucessful" status code

  Scenario: Registered user can not remove images from other's purchaseable item
    Given I am logged in as ricon
    When I remove an image from the stewie "purchaseable" item
    Then I should receive a "unauthorized" status code

  # Pending Item
  Scenario: Guest can not remove images from pending item
    Given I am not logged in
    When I remove an image from the stewie "pending" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can remove images from own pending item
    Given I am logged in as stewie
    When I remove an image from the stewie "pending" item
    Then I should receive a "delete sucessful" status code

  Scenario: Registered user can not remove images from other's pending item
    Given I am logged in as ricon
    When I remove an image from the stewie "pending" item
    Then I should receive a "unauthorized" status code
    
  # Disabled Item
  Scenario: Guest can not remove images from disabled item
    Given I am not logged in
    When I remove an image from the stewie "disabled" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not add images own disabled item
    Given I am logged in as stewie
    When I remove an image from the stewie "disabled" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not add images other's disabled item
    Given I am logged in as ricon
    When I remove an image from the stewie "disabled" item
    Then I should receive a "unauthorized" status code
  
  # Expired Item
  Scenario: Guest can not remove images from expired item
    Given I am not logged in
    When I remove an image from the stewie "expired" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not remove images from own expired item
    Given I am logged in as stewie
    When I remove an image from the stewie "expired" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can not remove images from other's expired item
    Given I am logged in as ricon
    When I remove an image from the stewie "expired" item
    Then I should receive a "unauthorized" status code
