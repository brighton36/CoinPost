@seed_users @seed_purchases
Feature: Mark Fulfilled
  In order to notify purchasers of order fulfillment
  as a registered user of the website
  I need to mark my sales as fulfilled

  @javascript
  Scenario: Stewie fulfills Ricon's order
    Given I am logged in as stewie
    When I visit the "stewie unfulfilled" purchase url
    And I click the "Ricons Purchase Payment Sent" payment row's "Mark Fulfilled"
    And I wait until the modal displays
    And I fill into the "Mark Fulfilled" form
      | purchase_fulfillment_notes | Please allow 4 days for shipping |
    And I click the active modal window's "Mark Fulfilled"
    And I wait for the "Mark Fulfilled Modal" loading indicator to finish
    Then I should see the modal popup success message

  @javascript
  Scenario: Stewie can't fulfill an order with an invalid notes field
    Given I am logged in as stewie
    When I visit the "stewie unfulfilled" purchase url
    And I click the "Ricons Purchase Payment Sent" payment row's "Mark Fulfilled"
    And I wait until the modal displays
    And I fill into the "Mark Fulfilled" form
      | purchase_fulfillment_notes | ``` |
    And I click the active modal window's "Mark Fulfilled"
    And I wait for the "Mark Fulfilled Modal" loading indicator to finish
    Then I should not see the modal popup success message

  @javascript
  Scenario: Stewie fulfills Ricon's order and ricon receives message
    Given I am logged in as stewie
    When I visit the "stewie unfulfilled" purchase url
    And I click the "Ricons Purchase Payment Sent" payment row's "Mark Fulfilled"
    And I wait until the modal displays
    And I fill into the "Mark Fulfilled" form
      | purchase_fulfillment_notes | Please allow 4 days for shipping |
    And I click the active modal window's "Mark Fulfilled"
    And I wait for the "Mark Fulfilled Modal" loading indicator to finish
    And I am not logged in
    And I am logged in as ricon
    When I visit the messages "view ricon inbox" url
    Then I should see that message "Here's an update from the seller regarding your Ricons Purchase Payment Sent" is unread

  Scenario Outline: User permissions on purchase fulfillment
    Given I am logged in as <user>
    When I request javascript responses
    And I post "<target>" to the "stewie mark fulfilled" purchase url
    Then I should receive a "<response>" http response code

  Examples:
    | user   | target                      | response     |
    | guest  | ricon's fulfilled           | Unauthorized |
    | stewie | ricon's fulfilled           | Unauthorized | 
    | ricon  | ricon's fulfilled           | Unauthorized | 
    | guest  | ricon's paid                | Unauthorized |
    | stewie | ricon's paid                | Success      | 
    | ricon  | ricon's paid                | Unauthorized | 
    | guest  | ricon's unpaid              | Unauthorized |
    | stewie | ricon's unpaid              | Success      | 
    | ricon  | ricon's unpaid              | Unauthorized | 
    | guest  | ricon's unpaid unfulfilled  | Unauthorized |
    | stewie | ricon's unpaid unfulfilled  | Unauthorized | 
    | ricon  | ricon's unpaid unfulfilled  | Unauthorized | 

