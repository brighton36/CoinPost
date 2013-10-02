@seed_policies @seed_categories @seed_users @seed_stewie_items 
Feature: Purchase item
  In order to own new things
  as a registered user of the website
  I want to purchase items for sale

  @javascript
  Scenario: Ricon buys an item from Stewie
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "show" url
    And I click "Buy this Item"
    And I click "Buy It!"
    And I wait for the "Item Purchase Modal" loading indicator to finish
    Then I should see the modal popup success message

  @javascript
  Scenario: Ricon can't buy an item with an invalid quantity
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "show" url
    And I click "Buy this Item"
    And I fill into the "Purchase Create" form
      | purchase_quantity_purchased | 0 |
    And I click "Buy It!"
    And I wait for the "Item Purchase Modal" loading indicator to finish
    Then I should not see the modal popup success message
    
  @javascript
  Scenario: Ricon buys quantity 2 and sees order total in the popup modal
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "show" url
    And I click "Buy this Item"
    And I fill into the "Purchase Create" form
      | purchase_quantity_purchased | 2 |
    And I click "Buy It!"
    And I wait for the "Item Purchase Modal" loading indicator to finish
    Then I should see the modal popup success message
    And I should see a modal purchase total of "16.0"

  @javascript
  Scenario: Ricon asks seller a question and seller receives message
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "show" url
    And I click "Buy this Item"
    And I click "Buy It!"
    And I wait for the "Item Purchase Modal" loading indicator to finish
    And I am not logged in
    And I am logged in as stewie
    When I visit the messages "view stewie inbox" url
    Then I should see that message "You just sold Stewie's Shiny Widget" is unread

  @javascript
  Scenario: Ricon asks seller a question and ricon receives message
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "show" url
    And I click "Buy this Item"
    And I click "Buy It!"
    And I wait for the "Item Purchase Modal" loading indicator to finish
    When I visit the messages "view ricon inbox" url
    Then I should see that message "You just bought Stewie's Shiny Widget" is unread
 
  Scenario Outline: User permissions on purchase create
    Given I am logged in as <user>
    When I post "<target>" to the stewie <destination> url
    Then I should receive a "<response>" http response code

  Examples:
    | user   | target                  | destination     | response     |
    | guest  | purchaseable            | create purchase | Unauthorized |
    | stewie | purchaseable            | create purchase | Unauthorized | 
    | ricon  | purchaseable            | create purchase | Success      | 
    | guest  | purchaseable with sales | create purchase | Unauthorized |
    | stewie | purchaseable with sales | create purchase | Unauthorized | 
    | ricon  | purchaseable with sales | create purchase | Success      | 
    | guest  | sold out                | create purchase | Unauthorized |
    | stewie | sold out                | create purchase | Unauthorized | 
    | ricon  | sold out                | create purchase | Unauthorized | 
    | guest  | pending                 | create purchase | Unauthorized |
    | stewie | pending                 | create purchase | Unauthorized | 
    | ricon  | pending                 | create purchase | Unauthorized | 
    | guest  | disabled                | create purchase | Unauthorized |
    | stewie | disabled                | create purchase | Unauthorized | 
    | ricon  | disabled                | create purchase | Unauthorized | 
    | guest  | expired                 | create purchase | Unauthorized |
    | stewie | expired                 | create purchase | Unauthorized | 
    | ricon  | expired                 | create purchase | Unauthorized | 

 
