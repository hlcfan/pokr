class BillingController < ApplicationController

  def show
    @orders = current_user.orders
  end

end
