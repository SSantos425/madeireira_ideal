class Supplier < ApplicationRecord
    validates :name, :address, :cnpj, :state_registration, presence: true
    has_many :purchases
end
