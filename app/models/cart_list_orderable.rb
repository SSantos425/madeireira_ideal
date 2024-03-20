class CartListOrderable < ApplicationRecord
  belongs_to :product
  belongs_to :cart_list
  belongs_to :client

  def total
    produto.sale_price * quantity
end
end
