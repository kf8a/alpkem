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
    Then I should see "Load failed."
      And I should see "No data was able to be loaded from this file."
    
  Scenario: Upload nothing
    Given I am on the new run page
    When I press "Upload"
    Then I should see "No file was selected to upload."
    
  Scenario: Upload a blank file
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "Lysimeter" from "Sample Type"
      And I attach the blank test file
      And I press "Upload"
    Then I should see "Load failed."
      And I should see "Data file is empty."

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
    Then I should see "T7R1"
      And I should see "2010-06-25"
      And I should see "0.0030 0.0120 0.0280"
      And I should see "Mean: 0.0143"
      And I should see "CV: 72.1305"
      And I should see "0.2520 0.3390 0.3460"
      And I should see "Mean: 0.3123"
      And I should see "CV: 13.6898"
      And I should see "Sample is not approved"

  Scenario: Upload GLBRC Deep Core data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "GLBRC Deep Core Nitrogen" from "Sample Type"
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
    Then I should see "G2R1 2010-06-25"
      And I should see "0.0360 0.0300 0.0200"
  
  Scenario: Upload GLBRC New Format Soil data
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "GLBRC Soil Sample (New)" from "Sample Type"
      And I attach the new GLBRC Soil test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."
      And I should see "Number of Samples: 50"

    When I follow "back"
    Then I should be on the runs page.

    When I follow "qc"
    Then I should see "G8R2 2010-06-25"
      And I should see "0.1800 0.1740 0.1860"

  Scenario: Upload a file that is a new GLBRC Soil Sample but did not work
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "GLBRC Soil Sample (New)" from "Sample Type"
      And I attach the slightly different new GLBRC soil test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."
  
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
    Then I should see "CFR1S1C1SUR 2001-09-17 0.1183 0.1314"
      And I should see "1.6748"

  Scenario: Upload GLBRC deepcore CN data file
    Given I am on the new run page
    When I select "June 25, 2010" as the "Sample Date" date
      And I select "June 25, 2010" as the "Start Date" date
      And I select "June 25, 2010" as the "Run Date" date
      And I select "CN Deep Core" from "Sample Type"
      And I attach GLBRC deepcore CN test file
      And I press "Upload"
    Then I should see "Run was successfully uploaded."
