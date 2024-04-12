class Purchase < ApplicationRecord
  validates :supplier_id,:nota_number,:serie,:issue_date,:receipt_date,:total_nota,:total_products,:shipping, presence: true
  belongs_to :supplier


  def total(valor)
  @purchase_lists = PurchaseList.where(purchase_id: valor)
    total_amount = 0

  @purchase_lists.each do |purschase_list|
      total_amount += purschase_list.total_parcial
    end

    total_amount
  end

  def total_compra(valor)
  @purchase_lists = PurchaseList.where(purchase_id: valor)
    total_amount = 0

  @purchase_lists.each do |purschase_list|
      total_amount += purschase_list.total_compra_parcial
    end

    total_amount
  end


end
