Feature: Manage user_sessions
  In order to enter the site
  An unsigned-in but valid user
  wants to be signed in
  
  Scenario: Login registered user
    Given I am on the new user_sessions page
    When I fill in "user_session_openid_identifier" with "registered user"
      And I press "Login"
    Then I should see "Login succesful!"
    
  Scenario: Don't login unregistered user
    Given I am on the new user_sessions page
    When I fill in "user_session_openid_identifier" with "notauser@example.com"
      And I press "Login"
    Then I should see "not an OpenID identifier"
