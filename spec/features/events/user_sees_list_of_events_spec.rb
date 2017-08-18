require 'rails_helper'

feature 'see events index' do
  scenario 'user signs in' do
    user = FactoryGirl.create(:user)
    event = FactoryGirl.create(:event)
    host = Host.create(user_id: user.id, event_id: event.id)
    visit root_path
    sign_in(user)

    expect(page).to have_content("Hello John!")
    expect(page).to have_content("#{event.name}")
    expect(page).to have_content("#{event.table_size_limit}")
  end


end
