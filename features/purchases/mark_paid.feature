@seed_users @seed_purchases
Feature: Mark Paid
  In order to enable sellers to fulfill an order
  as a registered user of the website
  I need to mark my purchases as paid

  Scenario: Ricon's marks payment paid
    Given I am logged in as ricon
    When I visit the "ricon unpaid" purchase url
    And I click the "Ricons Purchase Item" payment row's "Mark Paid"
    Then I should see "Your purchase was successfully marked paid."

  Scenario Outline: User permissions on purchase payment
    Given I am logged in as <user>
    When I post "<target>" to the "ricon mark paid" purchase url
    Then I should expect a "<location>" http redirect location

  Examples:
    | user   | target                     | location |
    | guest  | ricon's fulfilled          | Denied   |
    | stewie | ricon's fulfilled          | Denied   | 
    | ricon  | ricon's fulfilled          | Denied   | 
    | guest  | ricon's paid               | Denied   |
    | stewie | ricon's paid               | Denied   | 
    | ricon  | ricon's paid               | Denied   | 
    | guest  | ricon's unpaid             | Denied   |
    | stewie | ricon's unpaid             | Denied   | 
    | ricon  | ricon's unpaid             | users/rickon-stark/purchases/unpaid | 
    | guest  | ricon's unpaid unfulfilled | Denied   |
    | stewie | ricon's unpaid unfulfilled | Denied   | 
    | ricon  | ricon's unpaid unfulfilled | users/rickon-stark/purchases/unpaid | 
