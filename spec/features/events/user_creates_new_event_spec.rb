require 'rails_helper'

feature 'create a new event' do
  let!(:user) { FactoryGirl.create(:user) }

  scenario 'user adds an event' do
    visit root_path
    sign_in(user)
    click_link 'Add an event'
    fill_in 'Name', with: "Super fun event"
    fill_in 'Table size limit', with: 12
    fill_in 'side_a_first_name', with: "John"
    fill_in 'side_a_last_name', with: "Smith"
    fill_in 'side_b_first_name', with: "Jane"
    fill_in 'side_b_last_name', with: "Jones"
    click_button 'Create Event'

    expect(page).to have_content("Super fun event")
    expect(page).to have_content("Create Seating Arrangement")
  end

  scenario 'user missed field in event' do
    visit root_path
    sign_in(user)
    click_link 'Add an event'
    fill_in 'Name', with: "Super fun event"
      # Don't fill in table size limit
    fill_in 'side_a_first_name', with: "John"
    fill_in 'side_a_last_name', with: "Smith"
    fill_in 'side_b_first_name', with: "Jane"
    fill_in 'side_b_last_name', with: "Jones"
    click_button 'Create Event'

    expect(page).to have_content("Add an Event")
    expect(page).to have_content("Table size limit can't be blank")
  end

  scenario 'user misses field under event sides' do
    visit root_path
    sign_in(user)
    click_link 'Add an event'
    fill_in 'Name', with: "Super fun event"
    fill_in 'Table size limit', with: 12
    fill_in 'side_a_first_name', with: "John"
      # Don't fill in side_a last_name
      # Don't fill in side_b first_name
    fill_in 'side_b_last_name', with: "Jones"
    click_button 'Create Event'

    expect(page).to have_content("Add an Event")
    expect(page).to have_content("Last name can't be blank")
    # Does not report side_b error due to `if side_a.valid? && side_b.valid?`
    # Does not check `side_b.valid?` because `side_a.valid?` is already false
  end
end

# rspec spec/features/events/user_creates_new_event_spec.rb
