
class Expense < ApplicationRecord
    belongs_to :account_plan
  
    validates :name, presence: true
    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
  