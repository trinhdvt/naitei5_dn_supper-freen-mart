class Admin::OrdersController < Admin::AdminController
  include ApplicationHelper
  before_action :load_order, only: %i(show update)

  def index
    @orders = Order.status_search(params[:status]).newest
    @pagy, @orders = pagy(@orders, items: Settings.item.max_item_10)
  end

  def show; end

  def update
    new_stt = params[:status].to_sym
    @order.update_status new_stt

    errors_msg = @order.errors.full_messages.join(", ")
    if errors_msg.present?
      return redirect_with_msg(admin_order_path,
                               :warning, errors_msg)
    end

    @order.send_status_updated_email
    redirect_with_msg(admin_order_path,
                      :success, t(".successful_update"))
  end

  private

  def load_order
    @order = Order.includes(order_items: :product).find_by(id: params[:id])
    return if @order

    redirect_with_msg admin_orders_path, :warning, t(".not_found")
  end
end
