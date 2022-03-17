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
end
