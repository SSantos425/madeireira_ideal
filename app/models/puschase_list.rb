class PuschaseList < ApplicationRecord
  belongs_to :purchase
  belongs_to :product

  def total_parcial
    product. purchase_price* quantity
  end

  def total_compra_parcial
    product.purchase_price * quantity
  end
end
