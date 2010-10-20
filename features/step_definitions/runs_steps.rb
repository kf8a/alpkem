When /^I attach the Lysimeter test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "new_lysimeter.TXT")
  attach_file("data_file", path_to_test_file)
end

When /^I attach the Soil Sample test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "new_format_soil_samples_090415.TXT")
  attach_file("data_file", path_to_test_file)
end

When /^I attach the GLBRC Deep Core test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "GLBRC_deep_core_1106R4R5.TXT")
  attach_file("data_file", path_to_test_file)
end

When /^I attach the GLBRC Resin Strips test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "new_format_soil_samples_090415.TXT")
  attach_file("data_file", path_to_test_file)
end

When /^I attach the CN test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "DC01CFR1.csv")
  attach_file("data_file", path_to_test_file)
end

When /^I attach GLBRC deepcore CN test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "GLBRC_CN_deepcore.csv")
  attach_file("data_file", path_to_test_file)
end

When /^I attach the new GLBRC Soil test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "glbrc_soil_sample_new_format.txt")
  attach_file("data_file", path_to_test_file)
end

When /^I attach the slightly different new GLBRC soil test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "100419L.TXT")
  attach_file("data_file", path_to_test_file)
end

When /^I attach the blank test file$/ do
  path_to_test_file = Rails.root.join("test", "data", "blank.txt")
  attach_file("data_file", path_to_test_file)
end


Then /^I should see the following data:$/ do |expected_data_table|
  expected_data_table.diff!(tableish('table tr', 'td,th'))
end
