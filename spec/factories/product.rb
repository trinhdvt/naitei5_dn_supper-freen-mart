FactoryBot.define do
  factory :product do
    name {Faker::Food.fruits}
    description {Faker::Food.description}
    quantity {rand(1..1000)}
    price {Faker::Number.within(range: 1..100) * 1e3}
    image {Faker::Avatar.image}
    category
  end
end
