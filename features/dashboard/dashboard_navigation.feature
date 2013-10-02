@seed_categories @seed_policies @seed_stewie_items @seed_stewie_emails
Feature: Dashboard Index
  In order to navigate the site
  As a registered user of the website
  I want to browse items relevant to me

  Scenario: Site guest can't view the dashboard index
    Given I am not logged in
    When  I visit the dashboard index
    Then  I should see "You need to sign in or sign up before continuing"

  Scenario: Registered user can view the dashboard index
    Given I am logged in as stewie
    When I visit the dashboard index    
    Then I should see an "index_messages_table" table with 3 rows
    Then I should see an "active_items_table" table with 3 rows
    Then I should see an "pending_items_table" table with 2 rows
  
  Scenario: Site guest can't view the active items dashboard
    Given I am not logged in
    When  I visit the active items dashboard
    Then  I should see "You need to sign in or sign up before continuing"

  Scenario: Registered user can view the active items dashboard
    Given I am logged in as stewie
    When I visit the active items dashboard
    Then I should see an "active_items_table" table with 2 rows
  
  Scenario: Site guest can't view the pending items dashboard
    Given I am not logged in
    When  I visit the pending items dashboard
    Then  I should see "You need to sign in or sign up before continuing"

  Scenario: Registered user can view the pending items dashboard
    Given I am logged in as stewie
    When  I visit the pending items dashboard
    Then I should see an "pending_items_table" table with 1 rows
  
  Scenario: Site guest can't view the expired items dashboard
    Given I am not logged in
    When  I visit the expired items dashboard
    Then  I should see "You need to sign in or sign up before continuing"

  Scenario: Registered user can view the expired items dashboard
    Given I am logged in as stewie
    When  I visit the expired items dashboard
    Then I should see an "expired_items_table" table with 3 rows
