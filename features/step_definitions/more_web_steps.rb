When /^I follow the redirect$/ do
  follow_redirect! if redirect?
end

When /^(?:|I )select "([^\"]*)" as the "([^\"]*)" date$/ do |date_to_select, date_label|
  date = date_to_select.is_a?(Date) || date_to_select.is_a?(Time) ?
            date_to_select : Date.parse(date_to_select)
  select date.year.to_s, :from => "#{date_label}_1i"
  select date.strftime('%B'), :from => "#{date_label}_2i"
  select date.day.to_s, :from => "#{date_label}_3i"
end