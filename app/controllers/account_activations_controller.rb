class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]

    if user && !user.activated? && user.authenticated?(:activated, params[:id])
      user.activate
      flash[:success] = t ".success_message"
    else
      flash[:danger] = t ".failure_message"
    end

    redirect_to root_url
  end
end
