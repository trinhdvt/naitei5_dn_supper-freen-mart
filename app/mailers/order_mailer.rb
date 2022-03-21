class OrderMailer < ApplicationMailer
  def order_success_mail order
    @order = order
    @user = @order.user

    mail to: @user.email
  end

  def update_status_mail order
    @order = order
    @user = @order.user

    mail to: @user.email
  end
end
