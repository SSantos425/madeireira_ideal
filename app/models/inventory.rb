class Inventory < ApplicationRecord
  validates :product_id,:quantity, presence: true
  belongs_to :product
end
