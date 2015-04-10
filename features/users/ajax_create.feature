@seed_users @javascript
Feature: Ajax Create
  In order to get access to protected sections of the site
  A user
  Should be able to create an account via the ajax pop-up

    Scenario: User creates account via the pop-up modal
      Given I am not logged in
      When I visit the home page
      And I click "Sign-in or Create Account"
      And I wait until the modal displays
      And I click "Create an Account"
      And I wait until all animations have finished
      And I fill into the "Create User" modal form
        | user_name                  | ScottyMctesty |
        | user_email                 | scotty@spectest.com |
        | user_location              | Miami |
        | user_password              | please |
        | user_password_confirmation | please |
      And I click "Create my Account"
      And I wait until the "modal-body_created_user" div class is displayed
      Then I should see "User Account Created Successfully"

    Scenario: User cannot create account via modal with incomplete form
      Given I am not logged in
      When I visit the home page
      And I click "Sign-in or Create Account"
      And I wait until the modal displays
      And I click "Create an Account"
      And I wait until all animations have finished
      And I fill into the "Create User" modal form
        | user_name                  | ScottyMctesty |
        | user_email                 | scotty@spectest.com |
        | user_location              | Miami |
      And I click "Create my Account"
      And I wait for the "Create User" loading indicator to finish
      Then I should see "We had some error(s) while trying to create your account."
