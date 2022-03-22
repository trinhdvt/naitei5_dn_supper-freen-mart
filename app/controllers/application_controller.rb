class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  include CartsHelper
  include Admin::OrdersHelper

  before_action :set_locale, :init_cart

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_check
    return if logged_in?

    flash[:warning] = t "users.not_logged_in"
    store_location
    redirect_to signin_url
  end
end
