@no-txn
Feature: Manage runs
  In order to upload data
  A user
  wants to be able to choose from many formats
  
  Scenario: Upload incorrect sample type
    Given I am on the new run page
    When I select "May 4, 2010" as the "Sample Date" date
      And I select "May 3, 2010" as the "Start Date" date
      And I select "May 2, 2010" as the "Run Date" date
      And I select "Lysimeter" from "Sample Type"
      And I attach the test file
      And I press "Upload"
    Then I should see "Run was not uploaded."
    
  Scenario: Upload nothing
    Given I am on the new run page
    When I press "Upload"
    Then I should see "No file was selected to upload."
    
  Scenario: Upload actual data THIS DOES NOT WORK
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "Soil Sample" from "Sample Type"
      And I attach the test file
      And I upload the run
    Then I should see "Run was successfully uploaded."

