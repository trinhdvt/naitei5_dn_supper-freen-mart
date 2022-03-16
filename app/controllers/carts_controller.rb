class CartsController < ApplicationController
  before_action :get_product, :get_quantity, only: :create

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

  def get_quantity
    @quantity = params.require(:cart)
                      .values_at(:quantity)
                      .first
                      .to_i
    solve_invalid_req t(".invalid_qtt") if @quantity.zero?
  end

  def get_product
    product_id = params.require(:cart)
                       .values_at(:product_id)
                       .first
    @product = Product.find_by id: product_id
    solve_invalid_req t("products.not_found") unless @product
  end

  def solve_invalid_req message
    flash[:danger] = message
    redirect_to root_url
  end
end
