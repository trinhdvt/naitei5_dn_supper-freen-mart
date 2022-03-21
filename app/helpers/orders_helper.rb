module OrdersHelper
  def left_products order_items
    I18n.t("orders.index.product_count",
           count: pluralize(order_items.count - 1,
                            t("orders.index.singular")))
  end

  def first_prod order
    order.order_items.first.product
  end
end
