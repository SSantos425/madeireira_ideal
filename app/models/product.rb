class Product < ApplicationRecord
    validates :name, :unity, :sale_price, :purchase_price, presence: true

    has_many :orderables
    has_many :carts, through: :orderables

    has_many :cart_list_orderables
    has_many :cart_lists, through: :cart_list_orderables
end
