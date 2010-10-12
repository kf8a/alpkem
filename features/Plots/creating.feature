Feature: Creating plots
  In order to upload data that uses a new plot
  A user
  wants to be able to create a plot

  Scenario: Create a new plot set with a new study
    Given I am on the new plot page
    When I fill in "Study name" with "Junipers"
      And I fill in "Prefix" with "J"
      And I fill in "Number of treatments" with "10"
      And I fill in "Replicate prefix" with "S"
      And I fill in "Number of replicates" with "3"
      And I press "Submit"
    Then I should see "Junipers"
      And I should see "J1S1"
      And I should see "J10S3"

  Scenario: Add to the plot set with an old study
    Given the Juniper study exists
    When I go to the plots page
      And I follow "Junipers"
      And I follow "Edit"
      And I fill in "How many total treatments should there be?" with "11"
      And I fill in "How many total replicates should there be?" with "5"
      And I press "Submit"
    Then I should see "Junipers"
      And I should see "J1S1"
      And I should see "J11S5"
