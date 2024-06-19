class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.integer :bill_type
      t.float :down_payment
      t.float :remaining_payment
      t.float :total_value
      t.string :obs
      t.references :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
