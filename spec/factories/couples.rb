FactoryGirl.define do
  factory :couple do
    sequence(:first_name) {|n| "John_#{n}"}
    sequence(:last_name) {|n| "Doe_#{n}"}
    notes "Test notes"
  end
end
