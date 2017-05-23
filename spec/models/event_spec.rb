require 'rails_helper'

RSpec.describe Event, type: :model do

  describe "create event" do
    it "creates a valid event" do
      user = FactoryGirl.create(:user)
      event = FactoryGirl.create(:event)

      results = Event.all
      expect(results).to include(event)
    end
  end


end
