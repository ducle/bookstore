FactoryBot.define do
  
  factory :book do
    title { Faker::Commerce.product_name }
    isbn_10 { Faker::Commerce.promotion_code}
    isbn_13 { Faker::Commerce.promotion_code + '-123'}
    price { Faker::Commerce.price }
  end

end