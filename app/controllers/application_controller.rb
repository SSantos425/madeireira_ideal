class ApplicationController < ActionController::Base
  before_action :set_cash_register_last
  before_action :authenticate_user!

  

  def set_cash_register_last
    @cash_register_last = CashRegister.last
  end
end
