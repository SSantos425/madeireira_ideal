class BillsController < ApplicationController
  def index
    @bills = Bill.all
    @bills_received = Bill.where(total_value: 0)
    @bills_payment = BillsPayment.all
  end

  def receive_bills
    bill_id = params[:bill_id]
    quantity = params[:quantity].to_f

    bill = Bill.find_by(id: bill_id)
    bill.update(remaining_payment: bill.remaining_payment - quantity)

    # atualiza o valor do caixa
    CashRegister.last.update(balance: CashRegister.last.balance + quantity)

    # cria um registro no caixa
    CashRegisterList.create(cash_register_id: CashRegister.last.id, date: Date.today, balance: quantity,
                            note: "Contas a receber - Cliente: #{bill.obs} - Valor R$:#{quantity} - Falta pagar R$:#{bill.remaining_payment}", cash_register_type: 1)

    redirect_to bills_path
  end
end
