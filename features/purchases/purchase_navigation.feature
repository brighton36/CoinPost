@seed_users @seed_categories @seed_purchases
Feature: Purchase Navigation
  In order to facilitate commerce
  as a registered user of the website
  I need to navigate the purchase and sales interfaces
  
  Scenario Outline: User permissions on purchase interfaces
    Given I am logged in as <user>
    When I visit the "<destination>" purchase url
    Then  I should see <response>

  Examples:
    | user   | destination        | response                                           |
    | guest  | stewie fulfilled   | "You need to sign in or sign up before continuing" |
    | stewie | stewie fulfilled   | "Sales Requiring Fulfillment"                      | 
    | ricon  | stewie fulfilled   | "You are not authorized to access the requested resource." |
    | guest  | stewie unfulfilled | "You need to sign in or sign up before continuing" |
    | stewie | stewie unfulfilled | "Sales Requiring Fulfillment"                      | 
    | ricon  | stewie unfulfilled | "You are not authorized to access the requested resource." |
    | guest  | stewie paid        | "You need to sign in or sign up before continuing" |
    | stewie | stewie paid        | "Paid Purchases"                                   | 
    | ricon  | stewie paid        | "You are not authorized to access the requested resource." |
    | guest  | stewie unpaid      | "You need to sign in or sign up before continuing" |
    | stewie | stewie unpaid      | "Purchases Requiring Payment"                      | 
    | ricon  | stewie unpaid      | "You are not authorized to access the requested resource." |

