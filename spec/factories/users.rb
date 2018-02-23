FactoryBot.define do

  factory :user do
    sequence(:email) { |n| "user#{n}@bookstore.com" }
    password  "tlpassword"
  end

end