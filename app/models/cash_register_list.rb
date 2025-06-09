class CashRegisterList < ApplicationRecord
  belongs_to :cash_register, dependent: :destroy
  belongs_to :expense

end
