FactoryGirl.define do
  factory :guest do
    sequence(:first_name) {|n| "Invited_#{n}"}
    sequence(:last_name) {|n| "McGuest_#{n}"}
    notes "Guest test notes"
  end
end
