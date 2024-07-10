class CashRegisterList < ApplicationRecord
  belongs_to :cash_register
  belongs_to :expense
end
