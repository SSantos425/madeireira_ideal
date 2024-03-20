class CreatePuschaseLists < ActiveRecord::Migration[7.0]
  def change
    create_table :puschase_lists do |t|
      t.references :purchase, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.float :quantity

      t.timestamps
    end
  end
end
