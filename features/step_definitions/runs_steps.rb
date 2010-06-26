When /^I attach the test file$/ do
  path_to_test_file = File.join(Rails.root, "test", "data", "LTER_soil_test.TXT")
  attach_file("data_file", path_to_test_file, "text")
end