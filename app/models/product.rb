class Product < ApplicationRecord
  validates :name, :unity, :sale_price, :purchase_price, presence: true

  has_many :orderables, dependent: :destroy
  has_many :carts, through: :orderables

  has_many :cart_list_orderables, dependent: :destroy
  has_many :cart_lists, through: :cart_list_orderables

  def increase_sale_price_by_percentage(percentage)
    self.sale_price *= (1 + percentage / 100.0)
  end

  def decrease_sale_price_by_percentage(percentage)
    self.sale_price *= (1 - percentage / 100.0)
  end

  def increase_purchase_price_by_percentage(percentage)
    self.purchase_price *= (1 + percentage / 100.0)
  end

  def decrease_purchase_price_by_percentage(percentage)
    self.purchase_price *= (1 - percentage / 100.0)
  end
end
