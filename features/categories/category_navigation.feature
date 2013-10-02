@seed_categories @seed_policies @seed_users @seed_items
Feature: Category Navigation
  In order to purchase items
  As a guest user of the website
  I want to navigate the listings of items by their category

  Scenario: Site guest can browse all categories
    Given I am not logged in
    When I visit the main "Buy" link
    Then I should see "All Categories"
    And I should see items for sale 
  
  Scenario: Logged in user can browse all categories
    Given I am logged in
    When I visit the main "Buy" link
    Then I should see "All Categories"
    And I should see items for sale 

  Scenario: Guest user can browse a single category
    Given I am not logged in
    When I visit the home page
    And I click the "Electronics" category link
    Then I should see "Items in Electronics"
    And I should see items for sale 

  Scenario: Logged in user can browse a single category
    Given I am logged in
    When I visit the home page
    And I click the "Electronics" category link
    Then I should see "Items in Electronics"
    And I should see items for sale 
