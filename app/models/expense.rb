class Expense < ApplicationRecord
    belongs_to :account_plan
    has_many :cash_register_lists, dependent: :destroy
    validates :name, presence: true
end
