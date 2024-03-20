class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.references :supplier, null: false, foreign_key: true
      t.integer :nota_number
      t.integer :serie
      t.date :issue_date
      t.date :receipt_date
      t.float :total_nota
      t.float :total_products
      t.float :discount
      t.float :additon
      t.float :tax
      t.float :shipping
      t.integer :type

      t.timestamps
    end
  end
end
