class Bill < ApplicationRecord
  belongs_to :cart


  def falta_pagar(valor1,valor2)
    valor1-valor2
  end

  def find_name (cart)
    cart.orderables.first.client.name
  end
end
