require 'rails_helper'

feature 'deleting a guest and plusone' do

  scenario 'user deletes a guest without plusone' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
    a_parent_one = FactoryGirl.create(:guest, first_name: "A Parent",
      side: side_a.id, relationship_id: Relationship.second.id, event: event)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    expect(page).to have_content(a_parent_one.first_name)  #before deletion
    expect(page).to have_content("Guests - Count: 1")      #before deletion
    click_on "delete_#{a_parent_one.id}"
    expect(page).to_not have_content(a_parent_one.first_name) #after deletion
    expect(page).to have_content("Guests - Count: 0")         #after deletion
  end

  scenario 'user deletes a guest with a plusone' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, event_id: event.id)
    side_b = FactoryGirl.create(:couple, event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
    a_parent_one = FactoryGirl.create(:guest, first_name: "A Parent",
      side: side_a.id, relationship_id: Relationship.second.id, event: event)
    a_parent_two = FactoryGirl.create(:plusone, first_name: "A Parent Plus1",
      guest: a_parent_one)
    b_parent_one = FactoryGirl.create(:guest, first_name: "B Parent",
      side: side_b.id, relationship_id: Relationship.second.id, event: event)
    b_parent_two = FactoryGirl.create(:plusone, first_name: "B Parent Plus1",
      guest: b_parent_one)
    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    expect(page).to have_content(a_parent_one.first_name) #before deletion
    expect(page).to have_content("Guests - Count: 4")     #before deletion
    click_on "delete_#{a_parent_one.id}"
    expect(page).to_not have_content(a_parent_two.first_name) #after deletion
    expect(page).to have_content("Guests - Count: 2")         #after deletion
  end
end

# rspec spec/features/guests/user_deletes_guest_spec.rb
