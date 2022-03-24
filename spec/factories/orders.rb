FactoryBot.define do
  factory :order do
    user
    deliver_address {Faker::Address.full_address}
    receiver_name {Faker::Name.name}
    phone {"0974951234"}
  end
end
