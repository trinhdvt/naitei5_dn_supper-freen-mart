module Admin::OrdersHelper
  def status_color status
    case status.to_sym
    when :canceled
      :warning
    when :pending
      :info
    when :delivering
      :primary
    when :received
      :success
    when :rejected
      :danger
    end
  end

  def total_price_quantity price, quantity
    price * quantity
  end

  def status_with_key
    Order.statuses.map do |status, _|
      [t("statuses.#{status}"), status]
    end
  end
end
