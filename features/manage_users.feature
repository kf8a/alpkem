Feature: Manage users
  In order to enter the site
  A new user
  wants to sign up
  
  Scenario: Sign up new user
    Given I am on the new user page
    When I fill in "user_openid_identifier" with "New User"
      And I press "Create"
    Then I should see "Account registered."

