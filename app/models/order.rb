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

  scope :newest, ->{order created_at: :desc}
  scope :status_search, ->(status){where(status: status) if status.present?}

  class << self
    def status_attributes_for_select
      statuses.map do |status, id|
        [I18n.t("statuses.#{status}"), id]
      end
    end
  end
end
