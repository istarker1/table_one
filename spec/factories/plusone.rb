FactoryGirl.define do
  factory :plusone do
    sequence(:first_name) {|n| "Plus_#{n}"}
    sequence(:last_name) {|n| "One_#{n}"}
    notes "Plus One test notes"
  end
end
