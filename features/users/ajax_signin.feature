@seed_users @javascript
Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in using the ajax login controls

    Scenario: User signs in successfully
      Given I am not logged in
      When I visit the home page
      And I click "Sign-in or Create Account"
      And I wait until the modal displays
      And I fill into the "User Login Form" modal form
        | session_user_email    | rickonstark@spectest.com |
        | session_user_password | please                   |
      And I click "Sign-in"
      Then I should see "Rickon Stark"

    Scenario: User can't login with bad password
      Given I am not logged in
      When I visit the home page
      And I click "Sign-in or Create Account"
      And I wait until the modal displays
      And I fill into the "User Login Form" modal form
        | session_user_email    | rickonstark@spectest.com |
        | session_user_password | badpass                  |
      And I click "Sign-in"
      Then I should see "Invalid e-email and/or password"

    Scenario: User requests password reset link by email
      Given I am not logged in
      When I visit the home page
      And I click "Sign-in or Create Account"
      And I wait until the modal displays
      And I click "Forgot your password?"
      And I fill into the "Forgot Password Form" modal form
        | password_user_email    | rickonstark@spectest.com |
      And I click "E-mail me a reset link"
      And I wait until the "modal-body_password_reset_sent" div class is displayed
      Then I should see "Password Reset Instructions Sent"
      
    Scenario: User requests password reset link for invalid email
      Given I am not logged in
      When I visit the home page
      And I click "Sign-in or Create Account"
      And I wait until the modal displays
      And I click "Forgot your password?"
      And I fill into the "Forgot Password Form" modal form
        | password_user_email    | baduser@nonexist.com |
      And I click "E-mail me a reset link"
      Then I should see "Invalid e-email or unknown account."
