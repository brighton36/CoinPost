@seed_users @seed_stewie_emails
Feature: Message Reply
  In order to communicate with buyers and sellers
  As a registered user of the website
  I want to reply to messages

  Scenario: Stewie replys to an email
    Given I am logged in as stewie
    When Stewie replys to Message To Stewie One
    Then I should see "Your reply was sent successfully"
  
  Scenario: Stewie replys to an email and recipient gets reply
    Given I am logged in as stewie
    When Stewie replys to Message To Stewie One
    And I am not logged in
    And I am logged in as ricon
    When I visit the messages "view ricon inbox" url
    Then I should see that message "RE: Will you ship to Alaska?" is unread
  
  Scenario: Stewie can't send an invalid reply to an email
    Given I am logged in as stewie
    When I visit the messages "show stewie message" url
    And I click "Send a reply"
    And I fill into the "Message" form
      | message_subject |  |
      | message_body | Your sister is a penguin?    |
    And I click "Send your reply"
    Then I should see "There was a problem sending your reply"

