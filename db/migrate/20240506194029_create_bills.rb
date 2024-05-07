class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.integer :bill_type
      t.float :quantity
      t.float :total_value
      t.references :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
