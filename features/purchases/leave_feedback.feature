@seed_users @seed_purchases
Feature: Leave Feedback
  In order to maintain transaction accountability amongst users
  as a user of the website
  I need to be able to leave feedback on other users

  Scenario: Stewie visits leave feedback page
    Given I am logged in as stewie
    When I visit the "stewie needing feedback" purchase url
    Then I should see 4 "seller" feedback forms
    And I should see 4 "buyer" feedback forms
  
  @javascript
  Scenario: Stewie leaves seller feedback on Ricon
    Given I am logged in as stewie
    When I visit the "stewie needing feedback" purchase url
    And I click "purchase_rating_on_seller_1" on the first "Seller" feedback form
    And I fill into the first "Seller" feedback form
      | purchase[comment_on_seller] | Great seller - hooked it up |
    And I click the "Leave Feedback" button on the first "Seller" feedback form
    And I wait for the loading indicator to finish on the first "Seller" feedback form
    Then I should see the first "Seller" feedback form disappear

  @javascript
  Scenario: Stewie leaves buyer feedback on Ricon
    Given I am logged in as stewie
    When I visit the "stewie needing feedback" purchase url
    And I click "purchase_rating_on_purchaser_-1" on the first "Buyer" feedback form
    And I fill into the first "Buyer" feedback form
      | purchase[comment_on_purchaser] | He took forever to pay |
    And I click the "Leave Feedback" button on the first "Buyer" feedback form
    And I wait for the loading indicator to finish on the first "Buyer" feedback form
    Then I should see the first "Buyer" feedback form disappear
 
  @javascript
  Scenario: Stewie leaves invalid seller feedback on Ricon
    Given I am logged in as stewie
    When I visit the "stewie needing feedback" purchase url
    And I fill into the first "Seller" feedback form
      | purchase[comment_on_seller] | Great seller - hooked it up |
    And I click the "Leave Feedback" button on the first "Seller" feedback form
    And I wait for the loading indicator to finish on the first "Seller" feedback form
    Then I should not see the first "Seller" feedback form disappear

  @seed_feedback
  Scenario Outline: User permissions on leave feedback
    Given I am logged in as <user>
    When I request javascript responses
    And I post "<target>" to the "<url_user>" leave feedback as a "<for>"
    Then I should receive a "<response>" http response code

  Examples:
    # All these purchases were made by Ricon on items created by stewie:
    | user   | url_user | target                                  | for       | response      |
    | guest  | stewie | ricons purchase                         | seller    | Unauthorized  |
    | stewie | stewie | ricons purchase                         | seller    | Unauthorized  | 
    | ricon  | stewie | ricons purchase                         | seller    | Unauthorized  | 
    | guest  | stewie | ricons purchase payment sent            | seller    | Unauthorized  |
    | stewie | stewie | ricons purchase payment sent            | seller    | Unauthorized  | 
    | ricon  | stewie | ricons purchase payment sent            | seller    | Unauthorized  | 
    | guest  | stewie | ricons purchase item sent               | seller    | Unauthorized  |
    | stewie | stewie | ricons purchase item sent               | seller    | Unauthorized  | 
    | ricon  | stewie | ricons purchase item sent               | seller    | Unauthorized  | 
    | guest  | stewie | ricons purchase item sent no payment    | seller    | Unauthorized  |
    | stewie | stewie | ricons purchase item sent no payment    | seller    | Unauthorized  | 
    | ricon  | stewie | ricons purchase item sent no payment    | seller    | Unauthorized  | 
    | guest  | stewie | ricons purchase with seller feedback    | seller    | Unauthorized  |
    | stewie | stewie | ricons purchase with seller feedback    | seller    | Unauthorized  | 
    | ricon  | stewie | ricons purchase with seller feedback    | seller    | Unauthorized  | 
    | guest  | stewie | ricons purchase with purchaser feedback | seller    | Unauthorized  |
    | stewie | stewie | ricons purchase with purchaser feedback | seller    | Unauthorized  | 
    | ricon  | stewie | ricons purchase with purchaser feedback | seller    | Unauthorized  | 
    | guest  | stewie | ricons purchase                         | purchaser | Unauthorized  |
    | stewie | stewie | ricons purchase                         | purchaser | Success       | 
    | ricon  | stewie | ricons purchase                         | purchaser | Unauthorized  | 
    | guest  | stewie | ricons purchase payment sent            | purchaser | Unauthorized  |
    | stewie | stewie | ricons purchase payment sent            | purchaser | Success       | 
    | ricon  | stewie | ricons purchase payment sent            | purchaser | Unauthorized  | 
    | guest  | stewie | ricons purchase item sent               | purchaser | Unauthorized  |
    | stewie | stewie | ricons purchase item sent               | purchaser | Success       | 
    | ricon  | stewie | ricons purchase item sent               | purchaser | Unauthorized  | 
    | guest  | stewie | ricons purchase item sent no payment    | purchaser | Unauthorized  |
    | stewie | stewie | ricons purchase item sent no payment    | purchaser | Success       | 
    | ricon  | stewie | ricons purchase item sent no payment    | purchaser | Unauthorized  | 
    | guest  | stewie | ricons purchase with seller feedback    | purchaser | Unauthorized  |
    | stewie | stewie | ricons purchase with seller feedback    | purchaser | Success       | 
    | ricon  | stewie | ricons purchase with seller feedback    | purchaser | Unauthorized  | 
    | guest  | stewie | ricons purchase with purchaser feedback | purchaser | Unauthorized  |
    | stewie | stewie | ricons purchase with purchaser feedback | purchaser | Unauthorized  | 
    | ricon  | stewie | ricons purchase with purchaser feedback | purchaser | Unauthorized  | 
    | guest  | ricon  | ricons purchase                         | seller    | Unauthorized  |
    | stewie | ricon  | ricons purchase                         | seller    | Unauthorized  | 
    | ricon  | ricon  | ricons purchase                         | seller    | Success       | 
    | guest  | ricon  | ricons purchase payment sent            | seller    | Unauthorized  |
    | stewie | ricon  | ricons purchase payment sent            | seller    | Unauthorized  | 
    | ricon  | ricon  | ricons purchase payment sent            | seller    | Success       | 
    | guest  | ricon  | ricons purchase item sent               | seller    | Unauthorized  |
    | stewie | ricon  | ricons purchase item sent               | seller    | Unauthorized  | 
    | ricon  | ricon  | ricons purchase item sent               | seller    | Success       | 
    | guest  | ricon  | ricons purchase item sent no payment    | seller    | Unauthorized  |
    | stewie | ricon  | ricons purchase item sent no payment    | seller    | Unauthorized  | 
    | ricon  | ricon  | ricons purchase item sent no payment    | seller    | Success       | 
    | guest  | ricon  | ricons purchase with seller feedback    | seller    | Unauthorized  |
    | stewie | ricon  | ricons purchase with seller feedback    | seller    | Unauthorized  | 
    | ricon  | ricon  | ricons purchase with seller feedback    | seller    | Unauthorized  | 
    | guest  | ricon  | ricons purchase with purchaser feedback | seller    | Unauthorized  |
    | stewie | ricon  | ricons purchase with purchaser feedback | seller    | Unauthorized  | 
    | ricon  | ricon  | ricons purchase with purchaser feedback | seller    | Success       | 
    | guest  | ricon  | ricons purchase                         | purchaser | Unauthorized  |
    | stewie | ricon  | ricons purchase                         | purchaser | Unauthorized  | 
    | ricon  | ricon  | ricons purchase                         | purchaser | Unauthorized  | 
    | guest  | ricon  | ricons purchase payment sent            | purchaser | Unauthorized  |
    | stewie | ricon  | ricons purchase payment sent            | purchaser | Unauthorized  | 
    | ricon  | ricon  | ricons purchase payment sent            | purchaser | Unauthorized  | 
    | guest  | ricon  | ricons purchase item sent               | purchaser | Unauthorized  |
    | stewie | ricon  | ricons purchase item sent               | purchaser | Unauthorized  | 
    | ricon  | ricon  | ricons purchase item sent               | purchaser | Unauthorized  | 
    | guest  | ricon  | ricons purchase item sent no payment    | purchaser | Unauthorized  |
    | stewie | ricon  | ricons purchase item sent no payment    | purchaser | Unauthorized  | 
    | ricon  | ricon  | ricons purchase item sent no payment    | purchaser | Unauthorized  | 
    | guest  | ricon  | ricons purchase with seller feedback    | purchaser | Unauthorized  |
    | stewie | ricon  | ricons purchase with seller feedback    | purchaser | Unauthorized  | 
    | ricon  | ricon  | ricons purchase with seller feedback    | purchaser | Unauthorized  | 
    | guest  | ricon  | ricons purchase with purchaser feedback | purchaser | Unauthorized  |
    | stewie | ricon  | ricons purchase with purchaser feedback | purchaser | Unauthorized  | 
    | ricon  | ricon  | ricons purchase with purchaser feedback | purchaser | Unauthorized  | 
