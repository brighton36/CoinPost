@seed_users @seed_stewie_items @seed_stewie_reddit_items
Feature: Submit to Reddit
  In order to promote their post
  As a registered user of the website
  I want to submit my link to reddit

  Scenario Outline: User permission expectations on reddit submit action
    Given I am logged in as <user>
    When I post "<target>" to the reddit submit url
    Then I should expect a "<result>" http response

  Examples:
    | user   | target                  | result           |
    | guest  | Newly posted item       | Denied           |
    | stewie | Newly posted item       | Missing password | 
    | ricon  | Newly posted item       | Denied           |
    | guest  | Already posted item     | Denied           |
    | stewie | Already posted item     | Denied           | 
    | ricon  | Already posted item     | Denied           | 
    | guest  | Not yet listed item     | Denied           |
    | stewie | Not yet listed item     | Denied           | 
    | ricon  | Not yet listed item     | Denied           | 
