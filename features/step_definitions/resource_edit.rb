## Attributes

When(/^he changes the "([^"]*)" field to "([^"]*)"$/) do |field, value|
  fill_in field, with: value
end

## Buttons

When(/^he presses "([^"]*)"$/) do |arg|
  click_button arg
end

When(/^he saves$/) do
  click_button I18n.t(:save)
end

## Facebook

When(/^he connects his account to Facebook$/) do
  visit settings_path_to @consumer
  find_link(I18n.t(:connect, scope: :facebook)).click
end

When(/^he disconnects his account from Facebook$/) do
  visit settings_path_to(@current_user)
  find_link(I18n.t(:disconnect, scope: :facebook)).click
end

## State

When(/^he deletes ((his)|the (.*)) account$/) do |usr|
  if usr == 'his'
    visit settings_path_to(@current_user)
  else
    visit settings_path_to(instance_variable_get("@#{usr.parameterize.underscore}"))
  end
  click_button I18n.t(:delete)
  click_button I18n.t(:confirm)
end

When(/^he (un)?locks ((his)|the (.*)) account$/) do |un, usr|
  if usr == 'his'
    visit settings_path_to(@current_user)
  else
    visit settings_path_to(instance_variable_get("@#{usr.parameterize.underscore}"))
  end
  click_button I18n.t(un ? :unlock : :lock)
end
