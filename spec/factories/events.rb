FactoryGirl.define do
  factory :event do
    sequence(:name) {|n| "event#{n}"}
    table_size_limit 12
  end
end
