@seed_categories @seed_policies 
Feature: Item Creation
  In order to earn coins
  As a registered user of the website
  I want to post and manage my items for sale

  Scenario: Site guest can't post an item for sale
    Given I am not logged in
    When  I visit the main "Sell" link
    Then  I should see "You need to sign in or sign up before continuing"
    
  @javascript
  Scenario: Logged in user posts an item for sale
    Given I am logged in
    When I start a new item and get to the add images step
    And I click "Next - Preview Your Item"
    And I see "Verify this item before it goes live?"
    Then I should see "Shiny Widget"
    And  I click "Create Item"
    Then I should see "Your item was created successfully"

  @javascript
  Scenario: User posts an item for sale with images
    Given I am logged in
    When I start a new item and get to the add images step
    And I attach the image "rambo-tux.png" to "item_image[image]"
    And wait for the upload to finish
    And I click "Next - Preview Your Item"
    And I see "Verify this item before it goes live?"
    Then I should see an image labeled "rambo-tux.png"
    And  I click "Create Item"
    Then I should see "Your item was created successfully"
  
  @javascript
  Scenario: User posts an item for sale and sees their added image on the listing
    Given I am logged in
    When I start a new item and get to the add images step
    And I attach the image "rambo-tux.png" to "item_image[image]"
    And wait for the upload to finish
    And I click "Next - Preview Your Item"
    And  I click "Create Item"
    And  I visit the shiny widget url 
    Then I should see an image labeled "rambo-tux.png"
    And I should see "Shiny Widget"

  @javascript
  Scenario: User starts to post an item, removes an image, and does not see their item on the listing
    Given I am logged in
    When I start a new item and get to the add images step
    And I attach the image "ubuntu-logo.png" to "item_image[image]"
    And wait for the upload to finish
    And I attach the image "rambo-tux.png" to "item_image[image]"
    And wait for the upload to finish
    And I delete the item image "ubuntu-logo.png"
    And I click "Next - Preview Your Item"
    And  I click "Create Item"
    And  I visit the shiny widget url 
    Then I should see "Shiny Widget"
    And I should see an image labeled "rambo-tux.png"
    And I should not see an image labeled "ubuntu-logo.png"

  @javascript
  Scenario: User clicks back on Add Images
    Given I am logged in
    When I visit the main "Sell" link
    And I fill in a new item form
    And I click "Next - Add some images"
    And I see "Now let's add some images to this item"
    And I click "Back to Item Edit"
    Then I should see "Let's sell something"
    And the "item_title" field should contain "Shiny Widget"
  
  @javascript
  Scenario: User clicks back on Preview
    Given I am logged in
    When I visit the main "Sell" link
    And I fill in a new item form
    And I click "Next - Add some images"
    And I see "Now let's add some images to this item"
    And I attach the image "rambo-tux.png" to "item_image[image]"
    And wait for the upload to finish
    And I click "Next - Preview Your Item"
    And I click "Back To Edit Images"
    Then I should see "Now let's add some images to this item"
    And I should see an download row labeled "rambo-tux.png"

  @javascript
  Scenario: Logged in user posts an item for sale in USD
    Given I am logged in
    And the BTC to USD exchange rate is 2
    When I visit the main "Sell" link
    And I fill into the "Item" form
      |item_title              | Shiny Widget |
      |item_location           | Miami, FL |
      |item_quantity_listed         | 1 |
      |item_price_in_currency_price | 10.00000000 |
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
    And I visit the shiny widget url 
    And I should see "About $10.00 USD"
