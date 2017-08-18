require 'rails_helper'

feature 'create a new guest' do
  xscenario 'user adds a guest using default relationship' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
    visit root_path
    sign_in(user)
    click_link "#{event.name}"
    # click_link "Add a guest"
    fill_in 'guest_first_name', with: "Pops"
    fill_in 'guest_last_name', with: "Jones"
    select "Mother / Father", from: "Relationship"
    choose "guest_side_#{side_a.id}"
    fill_in "guest_notes", with: "Test guest"
    save_and_open_page
    click_button "Create Guest"

    # refresh_page

    expect(page).to have_content("Pops")
    expect(page).to have_content("Father")
    expect(page).to have_content("First name")
  end

  xscenario 'user adds a guest using a custom relationship' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
    visit root_path
    sign_in(user)
    click_link "#{event.name}"
    # click_link "Add a guest"
    fill_in 'guest_first_name', with: "Michael"
    fill_in 'guest_last_name', with: "Scott"
    fill_in 'Relationship', with: "Coworker"
    choose "guest_side_#{side_a.id}"
    fill_in "guest_notes", with: "Test guest"
    click_button "Create Guest"

    expect(page).to have_content("Michael Scott")
    expect(page).to have_content("Coworker")
    expect(page).to have_content("First name")
  end

  scenario 'user fails to add a guest' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    # click_link "Add a guest"
    # Does not fill in anything
    click_button "Create Guest"

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Side can't be blank")
  end

  scenario 'user leaves custom relationship blank' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    # click_link "Add a guest"
    fill_in 'guest_first_name', with: "Michael"
    fill_in 'guest_last_name', with: "Scott"
    # Does not fill in custom relationship
    choose "guest_side_#{side_a.id}"
    fill_in "guest_notes", with: "Test guest"
    click_button "Create Guest"

    # expect(page).to have_content("Custom Relationship?")
    expect(page).to have_content("Relationship can't be blank")
    expect(page).to have_content("Add a Guest") #new form has Guest capitalized
  end

end

# rspec spec/features/guests/user_adds_new_guest_spec.rb
