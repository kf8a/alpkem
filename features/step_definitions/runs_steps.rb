When /^I attach the Lysimeter test file$/ do
  pending
end

When /^I attach the Soil Sample test file$/ do
  path_to_test_file = File.join(Rails.root, "test", "data", "LTER_soil_test.TXT")
  attach_file("data_file", path_to_test_file, "text")
end

When /^I attach the GLBRC Deep Core test file$/ do
  path_to_test_file = File.join(Rails.root, "test", "data", "GLBRC_deep_core_1106R4R5.TXT")
  attach_file("data_file", path_to_test_file, "text")
end

When /^I attach the GLBRC Resin Strips test file$/ do
  path_to_test_file = File.join(Rails.root, "test", "data", "new_format_soil_samples_090415.TXT")
  attach_file("data_file", path_to_test_file, "text")
end

When /^I attach the CN test file$/ do
  path_to_test_file = File.join(Rails.root, "test", "data", "DC01CFR1.csv")
  attach_file("data_file", path_to_test_file, "text")
end

When /^I attach GLBRC deepcore CN test file$/ do
  path_to_test_file = File.join(Rails.root, "test", "data", "GLBRC_CN_deepcore.csv")
  attach_file("data_file", path_to_test_file, "text")
end

When /^I attach the new GLBRC Soil test file$/ do
  path_to_test_file = File.join(Rails.root, "test", "data", "glbrc_soil_sample_new_format.txt")
  attach_file("data_file", path_to_test_file, "text")
end


Then /^I should see the following data:$/ do |expected_data_table|
  expected_data_table.diff!(tableish('table tr', 'td,th'))
end
