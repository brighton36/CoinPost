@seed_users @seed_stewie_emails @seed_stewie_items
Feature: Message Navigation
  In order to communicate with buyers and sellers
  As a registered user of the website
  I want to view and navigate my received messages

  Scenario Outline: User permission expectations on message get actions
    Given I am logged in as <user>
    When I visit the messages "<destination>" url
    Then I should receive a "<response>" html response

  Examples:
    | user   | destination            | response               |
    | guest  | view stewie inbox      | Login                  |
    | stewie | view stewie inbox      | Messages in your Inbox | 
    | ricon  | view stewie inbox      | Denied                 | 
    | guest  | view stewie sent       | Login                  |
    | stewie | view stewie sent       | Sent Messages          | 
    | ricon  | view stewie sent       | Denied                 | 
    | guest  | view stewie trash      | Login                  |
    | stewie | view stewie trash      | Messages in your Trash | 
    | ricon  | view stewie trash      | Denied                 | 
    | guest  | show stewie message    | Login                  |
    | stewie | show stewie message    | Message To Stewie One  | 
    | ricon  | show stewie message    | Denied                 | 
    | oldnan | show stewie message    | Denied                 | 
    | guest  | reply stewie message   | Login                  |
    | stewie | reply stewie message   | Message To Stewie One  | 
    | ricon  | reply stewie message   | Denied                 | 
    | oldnan | reply stewie message   | Denied                 | 
 
  Scenario Outline: User message create permissions
    Given I am logged in as <user>
    When I post to the <destination> url
    Then I should receive a "<response>" http response code

  Examples:
    | user   | destination                 | response     |
    | guest  | create message to stewie    | Unauthorized |
    | stewie | create message to stewie    | Success      | 
    | ricon  | create message to stewie    | Success      | 
  
  Scenario Outline: User permission expectations on message trash actions
    Given I am logged in as <user>
    When I post "<target>" to the <destination> url
    Then I should expect a "<location>" http redirect location

  Examples:
    | user   | target                  | destination                 | location |
    | guest  | Message To Stewie One   | trash stewie messages       | Denied   |
    | stewie | Message To Stewie One   | trash stewie messages       | users/stewie-griffen/inbox | 
    | ricon  | Message To Stewie One   | trash stewie messages       | Denied   |
    | guest  | Message To Stewie Three | untrash stewie messages     | Denied   |
    | stewie | Message To Stewie Three | untrash stewie messages     | users/stewie-griffen/trashed-messages | 
    | ricon  | Message To Stewie Three | untrash stewie messages     | Denied   | 
    | guest  | Message To Stewie One   | create reply stewie message | Denied   |
    | stewie | Message To Stewie One   | create reply stewie message | users/stewie-griffen/inbox | 
    | ricon  | Message To Stewie One   | create reply stewie message | Denied   | 
    | oldnan | Message To Stewie One   | create reply stewie message | Denied   |

  Scenario Outline: User permission expectations on item question actions
    Given I am logged in as <user>
    When I post "<target>" to the stewie <destination> url
    Then I should receive a "<response>" http response code

  Examples:
    | user   | target                  | destination          | response     |
    | guest  | purchaseable            | create item question | Unauthorized |
    | stewie | purchaseable            | create item question | Success      | 
    | ricon  | purchaseable            | create item question | Success      | 
    | guest  | purchaseable with sales | create item question | Unauthorized |
    | stewie | purchaseable with sales | create item question | Success      | 
    | ricon  | purchaseable with sales | create item question | Success      | 
    | guest  | pending                 | create item question | Unauthorized |
    | stewie | pending                 | create item question | Unauthorized | 
    | ricon  | pending                 | create item question | Unauthorized | 
    | guest  | disabled                | create item question | Unauthorized |
    | stewie | disabled                | create item question | Success      | 
    | ricon  | disabled                | create item question | Success      | 
    | guest  | expired                 | create item question | Unauthorized |
    | stewie | expired                 | create item question | Success      | 
    | ricon  | expired                 | create item question | Success      | 

