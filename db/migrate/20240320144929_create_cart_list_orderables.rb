class CreateCartListOrderables < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_list_orderables do |t|
      t.references :product, null: false, foreign_key: true
      t.references :cart_list, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true
      t.float :quantity

      t.timestamps
    end
  end
end
