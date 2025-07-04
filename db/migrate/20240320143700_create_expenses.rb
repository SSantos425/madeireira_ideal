class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.references :account_plan, null: false, foreign_key: true

      t.timestamps
    end
  end
end