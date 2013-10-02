@seed_policies @seed_stewie_items @seed_stewie_item_images
Feature: Item Image Listing
  In order to manage my item images
  As a registered user of the website
  I want to see what images of my items are for sale

  # New Item
  Scenario: Guest can not list images from new item
    Given I am not logged in
    When I list the images in a new item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can list images from new item
    Given I am logged in as stewie
    When I list the images in a new item
    Then I should receive a "sucessful" status code

  # Purchaseable Item
  Scenario: Guest can not list images from purchaseable item
    Given I am not logged in
    When I list the images in the stewie "purchaseable" item
    Then I should receive a "unauthorized" status code

  Scenario: Registered user can list images from own purchaseable item
    Given I am logged in as stewie
    When I list the images in the stewie "purchaseable" item
    Then I should receive a "sucessful" status code

  Scenario: Registered user can not list images from other's purchaseable item
    Given I am logged in as ricon
    When I list the images in the stewie "purchaseable" item
    Then I should receive a "unauthorized" status code
