class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy

  enum role: {
    user: 0,
    admin: 1
  }, _prefix: true
end
