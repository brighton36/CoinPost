@seed_policies @seed_stewie_items
Feature: Item Navigation
  In order to purchase items
  As a user of the website
  I want to navigate the item details and listings

  Scenario Outline: User permissions on item show
    Given I am logged in as <user>
    When I visit the stewie "<target>" item "show" url
    Then I should see <response>

  Examples:
    | user   | target                  | destination     | response                |
    | guest  | purchaseable            | create purchase | "Stewie's Shiny Widget" |
    | stewie | purchaseable            | create purchase | "Stewie's Shiny Widget" |
    | ricon  | purchaseable            | create purchase | "Stewie's Shiny Widget" |
    | guest  | purchaseable with sales | create purchase | "Stewie's Shiny Widget With Sales" |
    | stewie | purchaseable with sales | create purchase | "Stewie's Shiny Widget With Sales" |
    | ricon  | purchaseable with sales | create purchase | "Stewie's Shiny Widget With Sales" |
    | guest  | sold out                | create purchase | "Stewie's Sold Out Widget" |
    | stewie | sold out                | create purchase | "Stewie's Sold Out Widget" |
    | ricon  | sold out                | create purchase | "Stewie's Sold Out Widget" |
    | guest  | pending                 | create purchase | authentication required |
    | stewie | pending                 | create purchase | "Stewie's Pending Shiny Widget" |
    | ricon  | pending                 | create purchase | access denied           |
    | guest  | disabled                | create purchase | "Stewie's Disabled Shiny Widget" |
    | stewie | disabled                | create purchase | "Stewie's Disabled Shiny Widget" |
    | ricon  | disabled                | create purchase | "Stewie's Disabled Shiny Widget" |
    | guest  | expired                 | create purchase | "Stewie's Expired Shiny Widget" |
    | stewie | expired                 | create purchase | "Stewie's Expired Shiny Widget" |
    | ricon  | expired                 | create purchase | "Stewie's Expired Shiny Widget" |
