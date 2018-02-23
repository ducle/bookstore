FactoryBot.define do
  
  factory :category do
    name { "Cat#{Time.now.to_i} fake#{Time.now.to_i} book" }
  end

end