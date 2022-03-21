class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum status: {
    canceled: 0,
    pending: 1,
    delivering: 2,
    received: 3,
    rejected: 4
  }, _prefix: true

  VN_PHONE_REGEX = Settings.regex.vn_phone.freeze

  validates :receiver_name, :deliver_address, presence: true
  validates :phone, format: {with: VN_PHONE_REGEX}, presence: true

  before_create :set_default_status

  scope :newest, ->{order created_at: :desc}
  scope :status_search, ->(status){where(status: status) if status.present?}

  def pending_to_deliver_receive new_stt
    status_pending? && [:delivering, :received].include?(new_stt)
  end

  def deliver_to_reject new_stt
    status_delivering? && new_stt == :rejected
  end

  def can_update_status new_stt
    status_delivering? && new_stt == :received ||
      status_pending? && new_stt == :rejected
  end

  def update_deliver_to_reject order
    ActiveRecord::Base.transaction do
      order.status = :rejected
      order.save!
      order.order_items.each do |item|
        product = item.product
        product.update! quantity: product.quantity + item.quantity
      end
    end
  rescue StandardError
    errors.add(:base, I18n.t("admin.orders.failed_update"))
  end

  class OutOfStockError < StandardError; end

  def update_pending_to_deliver_receive new_stt, order
    ActiveRecord::Base.transaction do
      order.status = new_stt
      order.save!
      order.order_items.each do |item|
        product = item.product
        new_quantity = product.quantity - item.quantity
        if new_quantity.negative?
          raise OutOfStockError, I18n.t("admin.orders.out_of_stock",
                                        name: product.name)
        end
        product.update! quantity: new_quantity
      end
    end
  rescue OutOfStockError => e
    errors.add :base, e.message
  rescue StandardError
    errors.add :base, I18n.t("admin.orders.failed_update")
  end

  def update_forward_backward new_stt
    return if update status: new_stt

    errors.add :base, I18n.t("admin.orders.failed_update")
  end

  def update_status new_stt
    if pending_to_deliver_receive new_stt
      update_pending_to_deliver_receive new_stt, self
    elsif deliver_to_reject new_stt
      update_deliver_to_reject self
    elsif can_update_status new_stt
      update_forward_backward new_stt
    else
      errors.add :base, I18n.t("admin.orders.failed_update")
    end
  end

  def total
    # calc total of order in the first time
    unless self[:total]
      self[:total] = order_items.map{|item| item.quantity * item.price}.sum
      save
    end
    self[:total]
  end

  private

  def set_default_status
    self.status = Order.statuses[:pending]
  end
end
