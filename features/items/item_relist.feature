@seed_categories @seed_policies @seed_stewie_items @seed_stewie_item_images @javascript
Feature: Item Relist
  In order to more efficiently sell products
  As a registered user of the website
  I want to repost my items for sale

  Scenario: Logged in user starts to repost an item for sale
    Given I am logged in as stewie
    When I visit the stewie "expired" item "relist" url
    Then the "item_title" field should contain "Stewie's Expired Shiny Widget"
    And I should see in the "item_category_ids" select field
      |Electronics|
      |Home Decorations|

  Scenario: Logged in user sees prior images in a reposted item for sale
    Given I am logged in as stewie
    When I visit the stewie "expired" item "relist" url
    And I click "Next - Add some images"
    Then I should see "Now let's add some images to this item"
    And I should see an download row labeled "ubuntu-logo.png"
  
  Scenario: Logged in user repost an item for sale and sees the item posted
    Given I am logged in as stewie
    When I visit the stewie "expired" item "relist" url
    And I click "Next - Add some images"
    And I click "Next - Preview Your Item"
    And I click "Create Item"
    When I visit the stewie "reposted expired" item "show" url
    Then I should see "Stewie's Expired Shiny Widget"
    And I should see an image labeled "ubuntu-logo.png"
