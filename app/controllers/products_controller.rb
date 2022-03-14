class ProductsController < ApplicationController
  before_action :load_product_by_slug, only: :show

  def show; end

  private

  def load_product_by_slug
    slug = params[:id]
    @product = Product.find_by slug: slug
    return if @product

    flash[:danger] = t ".not_found"
    redirect_to root_url
  end
end
