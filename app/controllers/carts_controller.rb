class CartsController < ApplicationController
  before_action :load_cart_products, :verify_cart, only: :show
  before_action :handle_param_quantity, :load_product, only: %i(create update)

  def show; end

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

  def update
    flash.now[:warning] = t ".insufficient" if @quantity > @product.quantity
    @new_qtt = [@quantity, @product.quantity].min
    update_cart @product.id, @new_qtt

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @product_id = params[:pid]
    if @product_id.nil?
      empty_cart
      flash[:success] = t ".empty_cart"
      return redirect_to root_url
    else
      update_cart @product_id, 0
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

  def load_cart_products
    @cart_product_ids = cart_items.keys.map(&:to_i)
    @products = Product.where(id: @cart_product_ids)
  end

  def verify_cart
    unknown_cart_items = @cart_product_ids - @products.map(&:id)
    unknown_cart_items.each{|id| update_cart id, 0}

    @quantity = cart_items.values.map(&:to_i)
  end

  def solve_invalid_req message
    flash[:danger] = message
    redirect_to root_url
  end
end
