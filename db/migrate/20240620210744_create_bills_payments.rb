class CreateBillsPayments < ActiveRecord::Migration[7.0]
  def change
    create_table :bills_payments do |t|
      t.float :down_payment
      t.float :total_value
      t.float :remaining_payment
      t.references :purchase, null: false, foreign_key: true

      t.timestamps
    end
  end
end
