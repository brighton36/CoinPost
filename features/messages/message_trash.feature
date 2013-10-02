@seed_users @seed_stewie_emails
Feature: Message Trash
  In order to manage my inbox
  As a registered user of the website
  I want to trash email, untrash email and empty my email trash

  Scenario: Stewie trashes an email
    Given I am logged in as stewie
    When I visit the messages "view stewie inbox" url
    And I select the "Message To Stewie One" message
    And I click "Trash Selected"
    Then I should see "The selected messages were sent to your trash"
  
  Scenario: Stewie trashes two emails and sees them in his trash
    Given I am logged in as stewie
    When I visit the messages "view stewie inbox" url
    And I select the "Message To Stewie One" message
    And I select the "Message To Stewie Two" message
    And I click "Trash Selected"
    And I visit the messages "view stewie trash" url
    Then I should see the message "Message To Stewie One"
    And I should see the message "Message To Stewie Two"

  Scenario: Stewie untrashes an email
    Given I am logged in as stewie
    When I visit the messages "view stewie trash" url
    And I select the "Message To Stewie Three" message
    And I click "Un-trash Selected"
    Then I should see "The selected messages were sent to your inbox"
    
  Scenario: Stewie untrashes an email and sees them in his inbox
    Given I am logged in as stewie
    When I visit the messages "view stewie trash" url
    And I select the "Message To Stewie Three" message
    And I click "Un-trash Selected"
    And I visit the messages "view stewie inbox" url
    Then I should see the message "Message To Stewie Three"
