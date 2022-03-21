class StaticPagesController < ApplicationController
  def home
    @type = params[:type]&.to_sym || :newest
    @pagy, @products = pagy Product.try(@type)
  end
end
