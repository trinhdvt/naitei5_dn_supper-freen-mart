class Admin::OrdersController < Admin::AdminController
  def index
    @orders = Order.status_search(params[:status_id]).newest
    @pagy, @orders = pagy(@orders, items: Settings.item.max_item_10)
  end
end
