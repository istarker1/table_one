require 'rails_helper'

feature 'create a new event' do
  scenario 'user adds an event' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    relationship = FactoryGirl.create(:relationship)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    click_link "Add a guest"
    fill_in 'First name', with: "Michael"
    fill_in 'Last name', with: "Scott"
    select "#{relationship.name}", from: "Relationship"
    choose "guest_side_#{side_a.id}"
    fill_in "Notes", with: "Test guest"
    click_button "Create Guest"

    expect(page).to have_content("Michael Scott")
    expect(page).to have_content("Add a guest")
  end

  scenario 'user fails to add a guest' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    relationship = FactoryGirl.create(:relationship)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    click_link "Add a guest"
    # Does not fill in anything
    click_button "Create Guest"

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Side can't be blank")
  end

end
