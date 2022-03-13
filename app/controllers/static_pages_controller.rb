class StaticPagesController < ApplicationController
  def home
    @trending_pagy, @trending_products = pagy(Product.trending,
                                              items: Settings.trending.max_item)

    @new_pagy, @new_products = pagy(Product.newest,
                                    items: Settings.newest.max_item)
  end
end
