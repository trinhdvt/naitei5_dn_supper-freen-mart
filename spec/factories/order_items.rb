FactoryBot.define do
  factory :order_item do
    order
    product
    quantity { rand(1...product.quantity) }
    price { product.price }
  end
end
