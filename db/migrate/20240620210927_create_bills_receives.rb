class CreateBillsReceives < ActiveRecord::Migration[7.0]
  def change
    create_table :bills_receives do |t|
      t.float :down_payment
      t.float :total_value
      t.float :remaining_payment
      t.string :obs
      t.references :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
