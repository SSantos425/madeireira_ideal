class CreateCashRegisterLists < ActiveRecord::Migration[7.0]
  def change
    create_table :cash_register_lists do |t|
      t.references :cash_register, null: false, foreign_key: true
      t.date :date
      t.float :balance
      t.string :note
      t.integer :cash_register_type
      t.references :expense, null: false, foreign_key: true

      t.timestamps
    end
  end
end
