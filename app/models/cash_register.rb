class CashRegister < ApplicationRecord
  belongs_to :user
  has_many :cash_register_lists, dependent: :destroy
end
