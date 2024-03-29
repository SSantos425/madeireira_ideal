class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :cpf
      t.string :customer_type
      t.integer :cep
      t.string :address
      t.string :district
      t.string :city
      t.string :state
      t.string :cnpj
      t.string :state_registration
      t.string :municipal_registration
      t.string :business_sector
      t.integer :ibge_code
      t.text :notes
      t.integer :number

      t.timestamps
    end
  end
end
