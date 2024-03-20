class Orderable < ApplicationRecord
  belongs_to :product
  belongs_to :cart
  belongs_to :client

  def total
    product.sale_price * quantity
  end
end
