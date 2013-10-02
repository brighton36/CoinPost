@seed_users @seed_stewie_emails
Feature: Message Navigation
  In order to communicate with buyers and sellers
  As a registered user of the website
  I want to view and navigate my received messages

  Scenario: Stewie views his inbox
    Given I am logged in as stewie
    When I visit the messages "view stewie inbox" url
    Then I should see "Messages in your Inbox"
    And I should see 2 messages in my messages table
    
  Scenario: Stewie views his sent items
    Given I am logged in as stewie
    When I visit the messages "view stewie sent" url
    Then I should see "Sent Messages"
    And I should see 2 messages in my messages table
  
  Scenario: Stewie views his trashed items
    Given I am logged in as stewie
    When I visit the messages "view stewie trash" url
    Then I should see "Messages in your Trash"
    And I should see 1 messages in my messages table
  
  Scenario: Stewie reads an email
    Given I am logged in as stewie
    When I visit the messages "show stewie message" url
    Then I should see "Message To Stewie One"

  Scenario: Stewie reads an email and sees it marked read
    Given I am logged in as stewie
    When I visit the messages "show stewie message" url
    And I visit the messages "view stewie inbox" url
    Then I should see that message "Message To Stewie One" is read
    And I should see that message "Message To Stewie Two" is unread
