FactoryBot.define do
  
  factory :book do
    title { "book#{Time.now.to_i} fake#{Time.now.to_i} title" }
    
  end

end