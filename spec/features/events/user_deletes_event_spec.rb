require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

feature 'Delete Event' do
  scenario 'user deletes and event' do

    DatabaseCleaner.clean

    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event, name: "Not happening")
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, first_name: "Bob A", event_id: event.id)
    side_b = FactoryGirl.create(:couple, first_name: "Jane B", event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
    guest = FactoryGirl.create(:guest, first_name: "A Parent",
      side: side_a.id, relationship_id: Relationship.second.id, event: event)
    plusone = FactoryGirl.create(:plusone, first_name: "A Parent Plus1",
      guest: guest)

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "Delete"
    guest_results = Guest.all
    plusone_results = Plusone.all

    expect(page).to_not have_content("#{event.name}")
    expect(guest_results).to eq([])
    expect(plusone_results).to eq([])

  end
end

# rspec spec/features/events/user_deletes_event_spec.rb
