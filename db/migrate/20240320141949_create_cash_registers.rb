class CreateCashRegisters < ActiveRecord::Migration[7.0]
  def change
    create_table :cash_registers do |t|
      t.references :user, null: false, foreign_key: true
      t.float :balance
      t.float :cash_replenishment
      t.date :date
      t.integer :cash_register_status
      t.float :open_value
      t.float :close_value
      t.float :quantity

      t.timestamps
    end
  end
end
