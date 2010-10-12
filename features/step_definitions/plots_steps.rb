Given /^the Juniper study exists$/ do
  steps %Q{
    Given I am on the new plot page
    When I fill in "Study name" with "Junipers"
      And I fill in "Prefix" with "J"
      And I fill in "Number of treatments" with "10"
      And I fill in "Replicate prefix" with "S"
      And I fill in "Number of replicates" with "3"
      And I press "Submit"
  }
end
