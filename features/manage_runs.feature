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
      And I should see "File not parsable."
    
  Scenario: Upload nothing
    Given I am on the new run page
    When I press "Upload"
    Then I should see "No file was selected to upload."

  Scenario: Upload Lysimeter data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "Lysimeter" from "Sample Type"
      And I attach the Lysimeter test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."
    
  Scenario: Upload Soil Sample data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "Soil Sample" from "Sample Type"
      And I attach the Soil Sample test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."

Scenario: Upload GLBRC Deep Core data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "GLBRC Deep Core" from "Sample Type"
      And I attach the GLBRC Deep Core test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."

