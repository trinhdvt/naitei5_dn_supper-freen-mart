module CartsHelper
  CART_KEY = :cart

  def init_cart
    set_cookie(CART_KEY, {}) unless cookies[CART_KEY]
  end

  def cart_items
    JSON.parse cookies[CART_KEY]
  end

  def quantity_in_cart product_id
    cart_items[product_id.to_s]&.to_i || 0
  end

  def update_cart product_id, new_quantity
    cart = cart_items
    cart[product_id] = new_quantity
    set_cookie CART_KEY, cart
  end

  private

  def set_cookie key, value
    cookies[key] = {
      value: value.to_json,
      expires: 3.months.from_now,
      httponly: true
    }
  end
end
