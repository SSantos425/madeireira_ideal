class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.float :balance
      t.float :discount
      t.float :addition
      t.date :date

      t.timestamps
    end
  end
end
