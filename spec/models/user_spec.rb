require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "create user" do
    it "creates a valid user" do
      user = User.create! do |u|
        u.first_name = "John"
        u.last_name = "Doe"
        u.email = "user@example.com"
        u.password = "password"
      end
      results = User.all

      expect(results).to include(user)
    end
  end

  describe "current user" do
    it "signs in an already registered user" do
      user = FactoryGirl.create(:user)
    end
  end

  # describe "current user" do
  #   it "does not create a second user with same info" do
  #     user = User.create! do |u|
  #       u.first_name = "John"
  #       u.last_name = "Doe"
  #       u.email = "user@example.com"
  #       u.password = "password"
  #     end
  #     copied_user = User.build! do |u|
  #       u.first_name = "John"
  #       u.last_name = "Doe"
  #       u.email = "user@example.com"
  #       u.password = "password"
  #     end
  #     expect(copied_user.save).to raise_error(ActiveRecord::RecordInvalid,'Validation failed: Email has already been taken')
  #   end
  # end

end
