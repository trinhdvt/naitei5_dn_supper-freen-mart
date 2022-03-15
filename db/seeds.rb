def create_user
  User.create!(name: "dvt", email: "dvt@gmail.com",
               activated: true)
end

def create_category
  10.times do |i|
    Category.create!(name: "category#{i}")
  end
end

def create_products
  30.times do |i|
    name = (i < 15) ? Faker::Food.vegetables : Faker::Food.fruits
    description = Faker::Food.description
    quantity = Faker::Number.between(from: 0, to: 100)
    price = Faker::Number.within(range: 1..100) * 1e3
    rating = Faker::Number.within(range: 1.0..5.0).round(2)
    image = "https://secure.gravatar.com/avatar/#{Digest::MD5.hexdigest(name)}"

    params = {
      name: name,
      description: description,
      quantity: quantity,
      price: price,
      rating: rating,
      image: image,
    }
    Category.all.sample(1)[0].products.create!(params)
  end
end

def create_order(user)
  max_product = 10

  order_products = Product.all.sample(max_product)
  quantity = Array.new(max_product) {rand(1..100)}
  total = 0
  order_products.each_with_index {|product, i| total += product.price * quantity[i]}

  status = rand(0..4)
  deliver_address = Faker::Address.full_address
  receiver_name = user.name
  phone = Faker::PhoneNumber.cell_phone
  order = user.orders.create!(total: total, status: status,
                              deliver_address: deliver_address,
                              receiver_name: receiver_name,
                              phone: phone)

  order_items_params = []
  order_products.each_with_index do |product, i|
    params = {
      product_id: product.id,
      quantity: quantity[i],
      price: product.price
    }
    order_items_params.push(params)
  end
  order.order_items.create!(order_items_params)
end

create_user
create_category
create_products
20.times {|_| create_order User.first}

