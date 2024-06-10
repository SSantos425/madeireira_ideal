class Bill < ApplicationRecord
  belongs_to :cart


  def falta_pagar(valor1,valor2)
    valor1-valor2
  end
end
