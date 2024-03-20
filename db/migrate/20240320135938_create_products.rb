class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :unity
      t.float :sale_price
      t.float :purchase_price

      t.timestamps
    end
  end
end
