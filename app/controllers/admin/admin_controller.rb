class Admin::AdminController < ApplicationController
  before_action :require_admin
  layout "admin"

  def require_admin
    redirect_to root_path unless logged_in? && is_admin?
  end
end
