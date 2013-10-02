@seed_users @javascript
Feature: Need Help
  In order to communicate with the coinpost admin
  As a user of coinpost
  I want to ask for help

  Scenario: Ricon asks for help
    Given I am logged in as ricon
    When I visit the Need Help? page
    And I fill into the "Message Create" form
      | message_subject | What's the deal? |
    And I fill into the tinymce fields
      | message_body | "Answer my <strong>damn</strong> question"|
    And I click "Send Question"
    And I wait until the "message_sent_successfully" div is displayed
    Then I should see "Your Question was sent Successfully"

  Scenario: Ricon asks for help and fills out the form incorrectly
    Given I am logged in as ricon
    When I visit the Need Help? page
    And I fill into the "Message Create" form
      | message_subject | |
    And I fill into the tinymce fields
      | message_body | "Answer my <strong>damn</strong> question"|
    And I click "Send Question"
    And I wait for the "Admin Message" loading indicator to finish
    Then I should see "can't be blank"

  Scenario: Visitor asks a question
    Given I am not logged in
    When I visit the Need Help? page
    And I fill into the "Message Create" form
      | message_from_email | visitor@somewhere.com |
      | message_subject | What's the deal? |
      | message_body | "Answer my damn question"|
    And I click "Send Question"
    And I wait until the "message_sent_successfully" div is displayed
    Then I should see "Your Question was sent Successfully"

  Scenario: Ricon asks for help and fills out the form incorrectly
    Given I am not logged in
    When I visit the Need Help? page
    And I fill into the "Message Create" form
      | message_from_email | visitor@somewhere.com |
      | message_subject | |
      | message_body | "Answer my damn question"|
    And I click "Send Question"
    And I wait for the "Admin Message" loading indicator to finish
    Then I should see "can't be blank"
