class ApplicationController < ActionController::Base
  include SessionsHelper
  include Pagy::Backend
  include CartsHelper

  before_action :set_locale, :init_cart

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
