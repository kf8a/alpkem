Feature: Creating plots
  In order to upload data that uses a new plot
  A user
  wants to be able to create a plot

  Scenario: Create a new plot set with a new study
    Given I am on the new plot page
    When I fill in "Study Name" with "Junipers"
      And I fill in "Prefix" with "J"
      And I fill in "Number of Treatments" with "10"
      And I fill in "Replicate Prefix" with "S"
      And I fill in "Number of Replicates" with "3"
      And I press "Submit"
    Then I should see "Junipers"
      And I should see "J1S1"
      And I should see "J10S3"
