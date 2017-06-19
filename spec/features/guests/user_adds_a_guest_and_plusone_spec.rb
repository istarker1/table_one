require 'rails_helper'

feature 'create a new guest and plusone' do
  scenario 'user adds a guest and plusone' do
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
    click_link "Add a guest"
    fill_in 'guest_first_name', with: "Pops"
    fill_in 'guest_last_name', with: "Jones"
    select "Mother / Father", from: "Relationship"
    choose "guest_side_#{side_a.id}"
    fill_in "guest_notes", with: "Test guest"
    fill_in "plusone_first_name", with: "Moms"
    fill_in "plusone_last_name", with: "Jones"
    click_button "Create Guest"

    expect(page).to have_content("Pops")
    expect(page).to have_content("Father")
    expect(page).to have_content("Moms Jones")
    expect(page).to have_content("Add a guest")
  end


  scenario 'user does not enter guest data but enters plusone ' do
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
    click_link "Add a guest"
    # Does not fill in anything on guest portion
    fill_in "plusone_first_name", with: "Moms"
    fill_in "plusone_last_name", with: "Jones"

    click_button "Create Guest"

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")
    expect(page).to have_content("Side can't be blank")
  end

  scenario 'user enters guest and incomplete plusone data' do
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
    click_link "Add a guest"
    fill_in 'guest_first_name', with: "Pops"
    fill_in 'guest_last_name', with: "Jones"
    select "Mother / Father", from: "Relationship"
    choose "guest_side_#{side_a.id}"
    fill_in "guest_notes", with: "Test guest"
    fill_in "plusone_first_name", with: "Moms"
    click_button "Create Guest"

    expect(page).to have_content("Last name can't be blank")
  end

end


# rspec spec/features/guests/user_adds_a_guest_and_plusone_spec.rb
