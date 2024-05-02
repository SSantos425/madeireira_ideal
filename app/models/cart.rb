class Cart < ApplicationRecord
    has_many :orderables
    has_many :products, through: :orderables
    has_many :clients, through: :orderables

    def total
        orderables.to_a.sum { |orderable| orderable.total }
    end

    def discounto(quantity)
        total - quantity
    end

    def additiono(quantity)
        total + quantity
    end
end
