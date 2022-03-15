class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :orders, through: :order_items

  scope :newest, ->{order created_at: :desc}
  scope :trending, (lambda do
    joins(order_items: [:order])
      .where("orders.status = ?", Order.statuses[:received])
      .group(:id).order("COUNT(order_items.product_id) DESC")
  end)

  before_save :create_slug

  def sold_count
    order_items.joins(:order)
               .where(orders: {status: Order.statuses[:received]})
               .sum(:quantity)
  end

  private

  def create_slug
    suffix = Digest::MD5.hexdigest(name + SecureRandom.uuid)[0..5]
    self.slug = [name.to_url, suffix].join("-")
  end
end
