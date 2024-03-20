class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.integer :cep
      t.string :address
      t.string :number
      t.string :complement
      t.string :district
      t.string :city
      t.string :state
      t.string :phone
      t.string :cnpj
      t.string :state_registration
      t.string :corporate_name

      t.timestamps
    end
  end
end
