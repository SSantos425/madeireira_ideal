class CashRegistersController < ApplicationController
  def index
    @cash_registers = CashRegister.all
    @cash_register_last = CashRegister.last
    @cash_register_lists = CashRegisterList.all
  end

  def show
    @cash_register = CashRegister.find(params[:id])
    @cash_register_lists = CashRegisterList.all
  end

  def new
    @cash_register = CashRegister.new
  end

  def create
    @cash_register = CashRegister.new(cash_register_params)
    @cash_register.update(open_value: @cash_register.balance, cash_register_status: 0)
    @cash_register.save
    if @cash_register.cash_replenishment.nil?
      @cash_register.update(cash_replenishment: 0)
      @cash_register.save
    else
      @cash_register.update(balance: @cash_register.balance + @cash_register.cash_replenishment)
      @cash_register.save
    end

    if @cash_register.save
      redirect_to cash_registers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @cash_register.update(cash_register_params)
      redirect_to cash_registers_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cash_register.destroy
    redirect_to cash_registers_path
  end

  def replenishment_or_withdrawl_cash_register
    account_plan_id = params[:account_plan_id]
    cash_register_id = params[:cash_register_id]
    date = params[:date]
    value = params[:value].to_f
    note = params[:notes]

    if params[:withdraw]
      cash_resgister_list = CashRegisterList.new(cash_register_id:, date:, balance: value, note:,
                                                  cash_register_type: 0, expense_id:account_plan_id)
      cash_resgister_list.save

      cash_resgister = CashRegister.last
      cash_resgister.update(balance: cash_resgister.balance - value)
      redirect_to cash_registers_path
    elsif params[:replenishment]
      cash_resgister_list = CashRegisterList.new(cash_register_id:, date:, balance: value, note:,
                                                  cash_register_type: 1, expense_id: account_plan_id)
      cash_resgister_list.save

      cash_resgister = CashRegister.last
      cash_resgister.update(balance: cash_resgister.balance + value)

      redirect_to cash_registers_path
    end
  end

  def close_cash_register
    cash_register = CashRegister.last
    # caixa_status:0-ABERTO | caixa_status:1- FECHADO

    cash_register.update(cash_register_status: 1, close_value: cash_register.balance)
    redirect_to cash_registers_path
  end

  def show_cash_registers
    @cash_register = CashRegister.all
  end

  private

  def cash_register_params
    params.require(:cash_register).permit(:user_id, :balance, :cash_replenishment, :date, :cash_register_status,
                                          :open_value, :close_value, :quantity)
  end
end
