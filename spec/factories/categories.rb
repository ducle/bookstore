FactoryBot.define do
  
  factory :category do
    name { Faker::Commerce.material }
  end

end