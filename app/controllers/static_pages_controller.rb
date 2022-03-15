class StaticPagesController < ApplicationController
  def home
    @trending_pagy, @trending_products = pagy(Product.trending,
                                              items: Settings.item.max_item_10)

    @new_pagy, @new_products = pagy(Product.newest,
                                    items: Settings.item.max_item_10)
  end
end
