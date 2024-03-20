class Client < ApplicationRecord
    validates :name, presence: true
    has_many :orderables
    has_many :carts, through: :orderables

    has_many :cart_list_orderable
    has_many :cart_list, through: :cart_list_orderable

    has_many :cart_lists
end
