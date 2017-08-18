require 'rails_helper'

feature 'editing a guest and plusone' do
  xscenario 'user adds a guest and plusone' do
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
    fill_in 'guest_first_name', with: "Pops"
    fill_in 'guest_last_name', with: "Jones"
    select "Mother / Father", from: "Relationship"
    choose "guest_side_#{side_a.id}"
    fill_in "guest_notes", with: "Test guest"
    fill_in "plusone_first_name", with: "Grandma"
    fill_in "plusone_last_name", with: "Jones"
    click_button "Create Guest"
    # save_and_open_page
    click_button "Edit"
    fill_in 'guest_first_name', with: "Old Man"

    expect(page).to have_content("Old Man")
    expect(page).to have_content("Father")
    expect(page).to have_content("Grandma Jones")
    expect(page).to have_content("Create Seating Arrangement")
  end
end

# rspec spec/features/guests/user_edits_guest_spec.rb
