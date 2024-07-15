class Expense < ApplicationRecord
    belongs_to :account_plan

    validates :name, presence: true
end