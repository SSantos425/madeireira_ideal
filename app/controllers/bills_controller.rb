class BillsController < ApplicationController
  def index
    @bills = BillsReceive.all
    @bills_received = BillsReceive.where(total_value: 0)
  end

  def receive_bills
    bill_id = params[:bill_id]
    quantity = params[:quantity].to_f

    bill = BillsReceive.find_by(id: bill_id)
    bill.update(remaining_payment: bill.remaining_payment - quantity)

    # atualiza o valor do caixa
    CashRegister.last.update(balance: CashRegister.last.balance + quantity)

    # cria um registro no caixa
    CashRegisterList.create(cash_register_id: CashRegister.last.id, date: Date.today, balance: quantity,
                            note: "Contas a receber - Cliente: #{bill.obs} - Valor R$:#{quantity} - Falta pagar R$:#{bill.remaining_payment}", cash_register_type: 1)

    redirect_to bills_path
  end

  def payment_bills
    bill_payment_id = params[:bill_payment_id]
    quantity = params[:quantity].to_f

    bill_payment = BillsPayment.find(bill_payment_id)

    bill_payment.update(remaining_payment: bill_payment.remaining_payment - quantity)

    # atualiza o valor do caixa
    CashRegister.last.update(balance: CashRegister.last.balance - quantity)

    # cria um registro no caixa
    CashRegisterList.create(cash_register_id: CashRegister.last.id, date: Date.today, balance: quantity,
                            note: "Contas a Pagar - Fornecedor: #{bill_payment.purchase.supplier.name} - Valor R$:#{quantity} - Falta pagar R$:#{bill_payment.remaining_payment}", cash_register_type: 2)
    redirect_to bills_payment_index_path
  end

  def bills_payment_index
    @bills_payment = BillsPayment.all
  end
end
