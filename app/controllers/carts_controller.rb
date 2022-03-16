class CartsController < ApplicationController
  before_action :handle_param_quantity, :load_product, only: :create

  def create
    current_qtt = quantity_in_cart @product.id
    new_qtt = current_qtt + @quantity
    if new_qtt > @product.quantity
      flash.now[:warning] = t ".insufficient"
    else
      update_cart @product.id, new_qtt
      flash.now[:success] = t ".success"
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def handle_param_quantity
    @quantity = params.dig(:cart, :quantity)&.to_i
    return if @quantity.positive?

    solve_invalid_req t(".invalid_qtt")
  end

  def load_product
    product_id = params.dig(:cart, :product_id)
    @product = Product.find_by id: product_id
    return if @product

    solve_invalid_req t("products.not_found")
  end

  def solve_invalid_req message
    flash[:danger] = message
    redirect_to root_url
  end
end
