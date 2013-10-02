@seed_policies @seed_categories @seed_users @seed_stewie_items @javascript
Feature: Message Creation
  In order to communicate with buyers and sellers
  As a registered user of the website
  I want to send messages 

  Scenario: Ricon asks seller a question
    Given I am logged in as ricon
    When I ask stewie a question about his purchaseable item
    Then I should see the modal popup success message

  Scenario: Ricon asks seller a question and seller receives answer
    Given I am logged in as ricon
    When I ask stewie a question about his purchaseable item
    And I am not logged in
    And I am logged in as stewie
    When I visit the messages "view stewie inbox" url
    Then I should see that message "Question for Item Stewie's Shiny Widget" is unread

  Scenario: Ricon can't ask seller an question with an invalid email
    Given I am logged in as ricon
    When I visit the stewie "purchaseable" item "show" url
    And I click "Ask the seller a question"
    And I fill into the tinymce fields
      |message_body | |
    And I click "Ask Question"
    And I wait for the "Ask Seller a Question" loading indicator to finish
    Then I should not see the modal popup success message
  
  Scenario: Ricon asks to contact user
    Given I am logged in as ricon
    When I contact stewie through his user detail page
    Then I should see the modal popup success message

  Scenario: Ricon asks to contact user and user receives answer
    Given I am logged in as ricon
    When I contact stewie through his user detail page
    And I am not logged in
    And I am logged in as stewie
    When I visit the messages "view stewie inbox" url
    Then I should see that message "Are you available?..." is unread

  Scenario: Ricon asks to contact user with an invalid message
    Given I am logged in as ricon
    When I visit the user "stewie show" url
    And I click "Send me a message"
    And I fill into the "Message Create" form
      | message_subject | |
    And I fill into the tinymce fields
      |message_body | "Answer my <strong>damn</strong> question"|
    And I click "Send Message"
    And I wait for the "Send User Message" loading indicator to finish
    Then I should not see the modal popup success message
  
