class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  enum status: {
    canceled: 0,
    pending: 1,
    delivering: 2,
    received: 3,
    rejected: 4
  }, _prefix: true
end
