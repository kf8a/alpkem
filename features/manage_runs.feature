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
      And I attach the Soil Sample test file
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
      And I should see "Number of Samples: 55"
      
    When I follow "back"
    Then I should see "2010-06-25 Soil Sample 55 samples qc delete"
    
    When I follow "qc"
    Then I should see "T7R1 2010-06-25 0.2953 0.2947 0.3034"

  Scenario: Upload GLBRC Deep Core data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "GLBRC Deep Core" from "Sample Type"
      And I attach the GLBRC Deep Core test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."

  Scenario: Upload GLBRC Resin Strips data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "GLBRC Resin Strips" from "Sample Type"
      And I attach the GLBRC Resin Strips test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."
      And I should see "Number of Samples: 38"
    
    When I follow "back"
    Then I should be on the runs page.

    When I follow "qc"
    Then I should see "G2R1 2010-06-25 0.0360 0.0300 0.0200"
  
  Scenario: Upload CN data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "CN Soil Sample" from "Sample Type"
      And I attach the CN test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."
    
    When I follow "back"
    Then I should be on the cn runs page.
    
    When I follow "qc"
    Then I should see "2001-09-17"
      And I should see "CFR1S1C1SUR"
      And I should see "0.1183"
      And I should see "1.6748"
