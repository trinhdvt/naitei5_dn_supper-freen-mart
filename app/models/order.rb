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

  VN_PHONE_REGEX = Settings.regex.vn_phone.freeze

  validates :receiver_name, :deliver_address, presence: true
  validates :phone, format: {with: VN_PHONE_REGEX}, presence: true

  before_create :set_default_status

  scope :newest, ->{order created_at: :desc}
  scope :status_search, ->(status){where(status: status) if status.present?}

  class << self
    def status_attributes_for_select
      statuses.map do |status, id|
        [I18n.t("statuses.#{status}"), id]
      end
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
