# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Inventory.destroy_all
Purchase.destroy_all
PurchaseList.destroy_all
Product.destroy_all
CashRegisterList.destroy_all
CashRegister.destroy_all
User.destroy_all
Supplier.destroy_all


user = User.create(email:"aaraujoborges@uol.com.br", password:830325)
cash_register = CashRegister.create(user_id:user.id, balance:0.0,date:Date.today, cash_replenishment:0.0,cash_register_status:0)

customer1 = Client.create(name:"CLIENTES DIVERSOS", customer_type:"Pessoa Fisica") #0 P.FISICA
customer2 = Client.create(name:"AB CONSTRUÇÕES", customer_type:"Pessoa Juridica") #1 P.JURIDICA



supplier1 = Supplier.create(
  name: "ABRAMAX MADEIRAS",
  cep: "68450-000",
  address: "VIA MARGEM DIREITA DO RIO MOJU",
  number: "0",
  complement: "-",
  district: "PARAISO",
  city: "MOJU",
  state: "Pará",
  phone: "91 99292-1254",
  cnpj: "08.990.062/0001-08",
  state_registration: "15.263.622-6",
  corporate_name: "ABRAMAX COMERCIO EXPORTAÇÃO DE MADEIRAS LTDA-EPP"
)

supplier2 = Supplier.create(
  name: "MADEIREIRA NOVA ERA",
  cep: "68450-000",
  address: "Rua Agropalma",
  number: "0",
  complement: "CAIXA POSTAL 083, ESQUINA COM RUA ARAUARI",
  district: "Altos",
  city: "MOJU",
  state: "Pará",
  phone: "91 99916-1022",
  cnpj: "08.242.838/0001-01",
  state_registration: "15.257.811-0",
  corporate_name: "NOVA ERA INDUSTRIA COMERCIO EXPORTAÇÃO DE MADEIRAS LIMITADA me"
)



# VIGAS
produto1 = Product.create(name: "VIGA 8X18", unity: "M", sale_price: 65, purchase_price: 27.46)

produto2 = Product.create(name: "VIGA 6X12 2,5M", unity: "PCA", sale_price: 60, purchase_price: 42)
produto3 = Product.create(name: "VIGA 6X12 3,0M", unity: "PCA", sale_price: 72, purchase_price: 50.40)
produto4 = Product.create(name: "VIGA 6X12 3,5M", unity: "PCA", sale_price: 84, purchase_price: 58.80)
produto5 = Product.create(name: "VIGA 6X12 4,0M", unity: "PCA", sale_price: 96, purchase_price: 67.20)
produto6 = Product.create(name: "VIGA 6X12 4,5M", unity: "PCA", sale_price: 108, purchase_price: 75.60)
produto7 = Product.create(name: "VIGA 6X12 5,0M", unity: "PCA", sale_price: 120, purchase_price: 84)
produto8 = Product.create(name: "VIGA 6X12 5,5M", unity: "PCA", sale_price: 132, purchase_price: 92.40)
produto9 = Product.create(name: "VIGA 6X12 6,0M", unity: "PCA", sale_price: 144, purchase_price: 100.80)
produto10 = Product.create(name: "VIGA 6X12 6,5M", unity: "PCA", sale_price: 156, purchase_price: 109.20)
produto11 = Product.create(name: "VIGA 6X12 7,0M", unity: "PCA", sale_price: 168, purchase_price: 117.60)
produto12 = Product.create(name: "VIGA 6X12 7,5M", unity: "PCA", sale_price: 180, purchase_price: 126)
produto13 = Product.create(name: "VIGA 6X12 8,0M", unity: "PCA", sale_price: 192, purchase_price: 134)
produto14 = Product.create(name: "VIGA 6X12 8,5M", unity: "PCA", sale_price: 204, purchase_price: 0.0)
produto15 = Product.create(name: "VIGA 6X12 9,0M", unity: "PCA", sale_price: 216, purchase_price: 0.0)
produto16 = Product.create(name: "VIGA 6X12 9,5M", unity: "PCA", sale_price: 228, purchase_price: 0.0)

# CAIBRO
produto0 = Product.create(name: "CAIBRO 1,0M - CACHORRO", unity: "PCA", sale_price: 7, purchase_price: 5)

produto17 = Product.create(name: "CAIBRO 3,5X6 2,5M", unity: "PCA", sale_price: 17.50, purchase_price: 12.25)
produto18 = Product.create(name: "CAIBRO 3,5X6 3,0M", unity: "PCA", sale_price: 21, purchase_price: 14.70)
produto19 = Product.create(name: "CAIBRO 3,5X6 3,5M", unity: "PCA", sale_price: 24.50, purchase_price: 17.15)
produto20 = Product.create(name: "CAIBRO 3,5X6 4,0M", unity: "PCA", sale_price: 28, purchase_price: 19.60)
produto21 = Product.create(name: "CAIBRO 3,5X6 4,5M", unity: "PCA", sale_price: 31.50, purchase_price: 22.05)
produto22 = Product.create(name: "CAIBRO 3,5X6 5,0M", unity: "PCA", sale_price: 35, purchase_price: 24.50)
produto23 = Product.create(name: "CAIBRO 3,5X6 5,5M", unity: "PCA", sale_price: 38.50, purchase_price: 26.95)
produto24 = Product.create(name: "CAIBRO 3,5X6 6,0M", unity: "PCA", sale_price: 42, purchase_price: 29.40)
produto25 = Product.create(name: "CAIBRO 3,5X6 6,5M", unity: "PCA", sale_price: 45.50, purchase_price: 31.45)
produto26 = Product.create(name: "CAIBRO 3,5X6 7,0M", unity: "PCA", sale_price: 49, purchase_price: 34.30)
produto27 = Product.create(name: "CAIBRO 3,5X6 7,5M", unity: "PCA", sale_price: 52.50, purchase_price: 36.75)
produto28 = Product.create(name: "CAIBRO 3,5X6 8,0M", unity: "PCA", sale_price: 56, purchase_price: 0.0)
produto29 = Product.create(name: "CAIBRO 3,5X6 8,5M", unity: "PCA", sale_price: 59.50, purchase_price: 0.0)

# FRECHAL
produto30 = Product.create(name: "FRECHAL 6X6", unity: "M", sale_price: 12, purchase_price: 8.40)

# RIPA
produto31 = Product.create(name: "RIPA 1,2X5", unity: "DZ", sale_price: 80, purchase_price: 48)

# VIGAS
Inventory.create(product_id: produto1.id, quantity: 0.0) #SEM ESTOQUE

Inventory.create(product_id: produto2.id, quantity: 32)
Inventory.create(product_id: produto3.id, quantity: 41)
Inventory.create(product_id: produto4.id, quantity: 71)
Inventory.create(product_id: produto5.id, quantity: 55)
Inventory.create(product_id: produto6.id, quantity: 37)
Inventory.create(product_id: produto7.id, quantity: 49)
Inventory.create(product_id: produto8.id, quantity: 27)
Inventory.create(product_id: produto9.id, quantity: 25)
Inventory.create(product_id: produto10.id, quantity: 25)
Inventory.create(product_id: produto11.id, quantity: 20)
Inventory.create(product_id: produto12.id, quantity: 11)
Inventory.create(product_id: produto13.id, quantity: 12)
Inventory.create(product_id: produto14.id, quantity: 5)
Inventory.create(product_id: produto15.id, quantity: 9)
Inventory.create(product_id: produto16.id, quantity: 0.0) #SEM ESTOQUE

Inventory.create(product_id: produto0.id, quantity: 0.0) #SEM ESTOQUE

Inventory.create(product_id: produto17.id, quantity: 180)
Inventory.create(product_id: produto18.id, quantity: 632)
Inventory.create(product_id: produto19.id, quantity: 398)
Inventory.create(product_id: produto20.id, quantity: 601)
Inventory.create(product_id: produto21.id, quantity: 544)
Inventory.create(product_id: produto22.id, quantity: 295)
Inventory.create(product_id: produto23.id, quantity: 219)
Inventory.create(product_id: produto24.id, quantity: 49)
Inventory.create(product_id: produto25.id, quantity: 0.0)
Inventory.create(product_id: produto26.id, quantity: 85)
Inventory.create(product_id: produto27.id, quantity: 32)
Inventory.create(product_id: produto28.id, quantity: 29)

Inventory.create(product_id: produto29.id, quantity: 0.0)
Inventory.create(product_id: produto30.id, quantity: 2691)
Inventory.create(product_id: produto31.id, quantity: 1680)

puts("Seed Completo!")