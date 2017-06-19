require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

feature 'create a seating arrangement' do
  scenario 'user creates a simple seating arrangement' do

    DatabaseCleaner.clean

    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, first_name: "Bob A", event_id: event.id)
    side_b = FactoryGirl.create(:couple, first_name: "Jane B", event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
  # create parents
    a_parent_one = FactoryGirl.create(:guest, first_name: "A Parent",
      side: side_a.id, relationship_id: Relationship.second.id, event: event)
    a_parent_two = FactoryGirl.create(:plusone, first_name: "A Parent Plus1",
      guest: a_parent_one)
    b_parent_one = FactoryGirl.create(:guest, first_name: "B Parent",
      side: side_b.id, relationship_id: Relationship.second.id, event: event)
    b_parent_two = FactoryGirl.create(:plusone, first_name: "B Parent Plus1",
      guest: b_parent_one)
  # create Grandparents
    FactoryGirl.create(:guest, first_name: "A Grandparent", side: side_a.id,
      relationship_id: Relationship.third.id, event: event)
    FactoryGirl.create(:plusone, first_name: "A Grandparent Plus1", guest: Guest.last)
    FactoryGirl.create(:guest, first_name: "B Grandmother", side: side_b.id,
      relationship_id: Relationship.third.id, event: event)
    FactoryGirl.create(:plusone, first_name: "B Grandparent Plus1", guest: Guest.last)
  # create A & B Aunts/Uncles
    2.times do
      FactoryGirl.create(:guest, first_name: "A Aunt", side: side_a.id,
        relationship_id: Relationship.where(name: "Aunt / Uncle (Mother's side)")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "A Uncle", guest: Guest.last)
      FactoryGirl.create(:guest, first_name: "B Aunt", side: side_b.id,
        relationship_id: Relationship.where(name: "Aunt / Uncle (Mother's side)")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "B Uncle", guest: Guest.last)
    end
  # create A Coworkers WITHOUT Plusones
    a_coworker_relationship = FactoryGirl.create(:relationship, name: "A Coworkers", event_id: event.id)
    4.times do
      FactoryGirl.create(:guest, first_name: "A Coworker", side: side_a.id,
        relationship_id: a_coworker_relationship.id, event: event)
    end
  # create A Coworkers WITH Plusones
    4.times do
      FactoryGirl.create(:guest, first_name: "A Coworker", side: side_a.id,
        relationship_id: a_coworker_relationship.id, event: event)
      FactoryGirl.create(:plusone, first_name: "A Coworker Plusone", guest: Guest.last)
    end
  # create B Coworkers WITHOUT Plusones
    b_coworker_relationship = FactoryGirl.create(:relationship, name: "B Coworkers", event_id: event.id)
    4.times do
      FactoryGirl.create(:guest, first_name: "B Coworker", side: side_b.id,
        relationship_id: b_coworker_relationship.id, event: event)
    end
  # create B Coworkers WITH Plusones
    3.times do
      FactoryGirl.create(:guest, first_name: "B Coworker", side: side_b.id,
        relationship_id: b_coworker_relationship.id, event: event)
      FactoryGirl.create(:plusone, first_name: "B Coworker Plusone", guest: Guest.last)
    end
  # create wedding party
    3.times do
      FactoryGirl.create(:guest, first_name: "A Party", side: side_a.id,
        relationship_id: Relationship.where(name: "Wedding Party")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "A Party Plus1", guest: Guest.last)
      FactoryGirl.create(:guest, first_name: "B Party", side: side_b.id,
        relationship_id: Relationship.where(name: "Wedding Party")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "B Party Plus1", guest: Guest.last)
    end
  # create A sibling and cousins
    FactoryGirl.create(:guest, first_name: "A Sister", side: side_a.id,
      relationship_id: Relationship.where(name: "Sister / Brother")[0].id, event: event)
    FactoryGirl.create(:plusone, first_name: "A Sister Plus1", guest: Guest.last)
    3.times do
      FactoryGirl.create(:guest, first_name: "A Cousin", side: side_a.id,
        relationship_id: Relationship.where(name: "Cousin (Father's side)")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "A Cousin Plus1", guest: Guest.last)
    end
  # create B cousins
    FactoryGirl.create(:guest, first_name: "B Cousin Mom Side", side: side_b.id,
      relationship_id: Relationship.where(name: "Cousin (Mother's side)")[0].id, event: event)
    FactoryGirl.create(:guest, first_name: "B Cousin Dad Side", side: side_b.id,
      relationship_id: Relationship.where(name: "Cousin (Father's side)")[0].id, event: event)
    FactoryGirl.create(:plusone, first_name: "B Cousin Dad Plus1", guest: Guest.last)
  # END CREATE GUEST LIST

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    click_link "Create Seating Arrangement"

    expect(page).to have_content("Table 1 Seated: 8")
    expect(page).to have_content("Total Guests: 61")

  end

  #--------------------------------------
  #--------------------------------------
  #--------------------------------------

  scenario 'user creates a seating arrangement with groups that take up more than one table' do

    DatabaseCleaner.clean

    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event, table_size_limit: 10)
    host = Host.create(user_id: user.id, event_id: event.id)
    side_a = FactoryGirl.create(:couple, first_name: "Bob A", event_id: event.id)
    side_b = FactoryGirl.create(:couple, first_name: "Jane B", event_id: event.id)
    event.update(side_a: side_a.id, side_b: side_b.id)
    load "#{Rails.root}/db/seeds.rb"
  # create parents
    a_parent_one = FactoryGirl.create(:guest, first_name: "A Parent",
      side: side_a.id, relationship_id: Relationship.second.id, event: event)
    a_parent_two = FactoryGirl.create(:plusone, first_name: "A Parent Plus1",
      guest: a_parent_one)
    b_parent_one = FactoryGirl.create(:guest, first_name: "B Parent",
      side: side_b.id, relationship_id: Relationship.second.id, event: event)
    b_parent_two = FactoryGirl.create(:plusone, first_name: "B Parent Plus1",
      guest: b_parent_one)
  # create Grandparents
    FactoryGirl.create(:guest, first_name: "A Grandparent", side: side_a.id,
      relationship_id: Relationship.third.id, event: event)
    FactoryGirl.create(:plusone, first_name: "A Grandparent Plus1", guest: Guest.last)
    FactoryGirl.create(:guest, first_name: "B Grandmother", side: side_b.id,
      relationship_id: Relationship.third.id, event: event)
    FactoryGirl.create(:plusone, first_name: "B Grandparent Plus1", guest: Guest.last)
  # create A & B Aunts/Uncles
    8.times do
      FactoryGirl.create(:guest, first_name: "A Aunt", side: side_a.id,
        relationship_id: Relationship.where(name: "Aunt / Uncle (Mother's side)")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "A Uncle", guest: Guest.last)
      FactoryGirl.create(:guest, first_name: "B Aunt", side: side_b.id,
        relationship_id: Relationship.where(name: "Aunt / Uncle (Mother's side)")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "B Uncle", guest: Guest.last)
    end
  # create A Coworkers WITHOUT Plusones (none with Plusones)
    a_coworker_relationship = FactoryGirl.create(:relationship, name: "A Coworkers", event_id: event.id)
    7.times do
      FactoryGirl.create(:guest, first_name: "A Coworker", side: side_a.id,
        relationship_id: a_coworker_relationship.id, event: event)
    end
  # create B Coworkers WITHOUT Plusones
    b_coworker_relationship = FactoryGirl.create(:relationship, name: "B Coworkers", event_id: event.id)
    4.times do
      FactoryGirl.create(:guest, first_name: "B Coworker", side: side_b.id,
        relationship_id: b_coworker_relationship.id, event: event)
    end
  # create B Coworkers WITH Plusones
    3.times do
      FactoryGirl.create(:guest, first_name: "B Coworker", side: side_b.id,
        relationship_id: b_coworker_relationship.id, event: event)
      FactoryGirl.create(:plusone, first_name: "B Coworker Plusone", guest: Guest.last)
    end
  # create wedding party
    3.times do
      FactoryGirl.create(:guest, first_name: "A Party", side: side_a.id,
        relationship_id: Relationship.where(name: "Wedding Party")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "A Party Plus1", guest: Guest.last)
      FactoryGirl.create(:guest, first_name: "B Party", side: side_b.id,
        relationship_id: Relationship.where(name: "Wedding Party")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "B Party Plus1", guest: Guest.last)
    end
  # create A sibling and cousins
    FactoryGirl.create(:guest, first_name: "A Sister", side: side_a.id,
      relationship_id: Relationship.where(name: "Sister / Brother")[0].id, event: event)
    # FactoryGirl.create(:plusone, first_name: "A Sister Plus1", guest: Guest.last)
    3.times do
      FactoryGirl.create(:guest, first_name: "A Cousin", side: side_a.id,
        relationship_id: Relationship.where(name: "Cousin (Father's side)")[0].id, event: event)
      FactoryGirl.create(:plusone, first_name: "A Cousin Plus1", guest: Guest.last)
    end
  # create B cousins
    FactoryGirl.create(:guest, first_name: "B Cousin Mom Side", side: side_b.id,
      relationship_id: Relationship.where(name: "Cousin (Mother's side)")[0].id, event: event)
    FactoryGirl.create(:guest, first_name: "B Cousin Dad Side", side: side_b.id,
      relationship_id: Relationship.where(name: "Cousin (Father's side)")[0].id, event: event)
    FactoryGirl.create(:plusone, first_name: "B Cousin Dad Plus1", guest: Guest.last)
  # END CREATE GUEST LIST

    visit root_path
    click_link 'Sign In'
    fill_in 'Email', with: "#{user.email}"
    fill_in 'Password', with: "#{user.password}"
    click_button 'Log in'
    click_link "#{event.name}"
    click_link "Create Seating Arrangement"

    expect(page).to have_content("Table 1 Seated: 10")
    expect(page).to have_content("Total Guests: 79")

  end
end

# spec/features/events/create_seating_chart_spec.rb
