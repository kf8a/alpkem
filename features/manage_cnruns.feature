Feature: Manage runs
  In order to analyze samples
  A user
  wants to be able to upload data
  
  Scenario: Upload nothing
    Given I am on the new cn run page
    When I press "Upload"
    Then I should see "No file was selected to upload."

  Scenario: Upload data
    Given I am on the new cn run page
    When I attach the CN test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."
