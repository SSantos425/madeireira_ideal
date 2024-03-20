class CreateCartLists < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_lists do |t|
      t.references :client, null: false, foreign_key: true
      t.float :balance
      t.integer :payment_method
      t.date :date
      t.float :discoutn
      t.float :additon

      t.timestamps
    end
  end
end
