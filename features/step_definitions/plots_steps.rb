Given /^the Juniper study exists$/ do
  steps %Q{
    Given I am on the new plot page
    When I fill in "Study Name" with "Junipers"
      And I fill in "Prefix" with "J"
      And I fill in "Number of Treatments" with "10"
      And I fill in "Replicate Prefix" with "S"
      And I fill in "Number of Replicates" with "3"
      And I press "Submit"
  }
end
