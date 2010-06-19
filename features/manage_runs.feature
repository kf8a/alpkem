Feature: Manage runs
  In order to upload data
  A user
  wants to be able to choose from many formats
  
  Scenario: Upload incorrect sample type
    Given I am on the new run page
    When I select "Lysimeter" from "Sample Type"
      And I attach the test file
      And I press "Upload"
    Then I should see "Run was not uploaded"
    
  Scenario: Upload nothing
    Given I am on the new run page
    When I press "Upload"
    Then I should see "Run was not uploaded"
