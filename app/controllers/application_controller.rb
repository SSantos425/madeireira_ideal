class ApplicationController < ActionController::Base
  before_action :set_render_cart
  before_action :set_cash_register_last
  before_action :initialize_cart
  before_action :authenticate_user!

  def set_render_cart
    @render_cart = true
  end

  def initialize_cart
    @cart ||= Cart.find_by(id: session[:cart_id])

    return unless @cart.nil?

    @cart = Cart.create(balance: 0, discount: 0, addition: 0, date: nil)
    session[:cart_id] = @cart.id
  end

  def set_cash_register_last
    @cash_register_last = CashRegister.last
  end
end
