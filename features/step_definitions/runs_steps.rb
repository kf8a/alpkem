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
