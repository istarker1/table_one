require 'rails_helper'

feature 'check for event hosts for security' do
  scenario 'user tries to edit an event he is not a host of' do
    legit_user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event, name: "SUPER FUN EVENT")
    host = Host.create(user_id: legit_user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    false_user = FactoryGirl.create(:user)
    load "#{Rails.root}/db/seeds.rb"
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{false_user.email}"
    fill_in 'Password', with: "#{false_user.password}"
    click_button 'Log in'
    visit "http://localhost:3000/events/#{event.id}"

    expect(page).to_not have_content("SUPER FUN EVENT")
    expect(page).to have_content("You are not authorized to view this page")
  end

end


# rspec spec/features/users/user_tries_to_edit_another_users_event_spec.rb
