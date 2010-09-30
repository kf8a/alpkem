Feature: Creating plots
  In order to upload data that uses a new plot
  A user
  wants to be able to create a plot

  Scenario: Create a new plot set
    Given I am on the new plot page
    When I select "New Study" from "Study"
      And I press "Next"
      And I fill in "Study Name" with "Junipers"
      And I fill in "Prefix" with "J"
      And I fill in "Number of Treatments" with "10"
      And I fill in "Replicate Prefix" with "S"
      And I fill in "Number of Replicates" with "3"
      And I press "Preview"
    Then I should see "30"
      And I should see "J1S1"
      And I should see "J10S3"

    When I press "Confirm"
      Then I should see "Junipers"
