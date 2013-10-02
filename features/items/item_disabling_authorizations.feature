@seed_policies @seed_stewie_items
Feature: Item Disabling
  In order to manage my listings
  As a registered user of the website
  I want to delist my items from the site

  Scenario Outline: User permission expectations on message trash actions
    Given I am logged in as <user>
    When I delist the stewie "<item>" item 
    Then I should see <response>

  Examples:
    | user   | item                    | response                |
    | guest  | purchaseable            | authentication required | 
    | guest  | purchaseable with sales | authentication required | 
    | stewie | purchaseable            | access denied           |
    | stewie | purchaseable with sales | "Your item was delisted successfully." |
    | ricon  | purchaseable            | access denied           |
    | ricon  | purchaseable with sales | access denied           |
    | guest  | pending                 | authentication required |
    | stewie | pending                 | access denied           |
    | ricon  | pending                 | access denied           |
    | guest  | disabled                | authentication required | 
    | stewie | disabled                | access denied           |
    | ricon  | disabled                | access denied           |
    | guest  | expired                 | authentication required |
    | stewie | expired                 | access denied           |
    | ricon  | expired                 | access denied           |
