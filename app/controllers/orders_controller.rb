class OrdersController < ApplicationController
  before_action :logged_in_check, only: :create
  before_action :load_selected_products, :build_order_with_items, only: :create

  def create
    if @order.save
      empty_cart @products.ids
      @order.send_order_success_email

      flash[:success] = t ".success"
      return redirect_to root_url
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def order_params
    params.permit(:receiver_name, :phone, :deliver_address)
  end

  def load_selected_products
    selected_pids = params[:product_ids].map(&:to_i)
    @products = Product.in_ids selected_pids
    return if @products.ids == selected_pids

    flash[:error] = t ".invalid_products"
    redirect_to cart_url
  end

  def build_order_with_items
    @order = current_user.orders.build(order_params)
    @products.each do |product|
      @order.order_items.build(
        product_id: product.id,
        quantity: quantity_in_cart(product.id),
        price: product.price
      )
    end
  end
end
