class CartList < ApplicationRecord
  has_many :cart_list_orderables
  has_many :products, through: :cart_list_orderables
  has_many :clients, through: :cart_list_orderables

  belongs_to :client
end
