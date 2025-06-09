class CashRegister < ApplicationRecord
  belongs_to :user
  validates :balance, :cash_replenishment, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :date, presence: true
end
