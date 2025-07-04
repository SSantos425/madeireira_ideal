BillsPayment.destroy_all
Orderable.destroy_all
Cart.destroy_all
Client.destroy_all
Inventory.destroy_all
PurchaseList.destroy_all
Purchase.destroy_all
Product.destroy_all
CashRegisterList.destroy_all
CashRegister.destroy_all
User.destroy_all
Supplier.destroy_all
Expense.destroy_all
AccountPlan.destroy_all

# cart = Cart.create(date:Date.today)
user = User.create(email: 'admin@admin.com', password: 123_456)
CashRegister.create(user_id: user.id, open_value: 0.0, balance: 0.0, date: Date.today, cash_replenishment: 0.0,
                    cash_register_status: 0)

Client.create(name: 'CLIENTES DIVERSOS', customer_type: 'Pessoa Fisica') # 0 P.FISICA
Client.create(name: 'AB CONSTRUÇÕES', customer_type: 'Pessoa Juridica') # 1 P.JURIDICA

Supplier.create(
  name: 'ABRAMAX MADEIRAS',
  cep: '68450-000',
  address: 'VIA MARGEM DIREITA DO RIO MOJU',
  number: '0',
  complement: '-',
  district: 'PARAISO',
  city: 'MOJU',
  state: 'Pará',
  phone: '91 99292-1254',
  cnpj: '08.990.062/0001-08',
  state_registration: '15.263.622-6',
  corporate_name: 'ABRAMAX COMERCIO EXPORTAÇÃO DE MADEIRAS LTDA-EPP'
)

Supplier.create(
  name: 'MADEIREIRA NOVA ERA',
  cep: '68450-000',
  address: 'Rua Agropalma',
  number: '0',
  complement: 'CAIXA POSTAL 083, ESQUINA COM RUA ARAUARI',
  district: 'Altos',
  city: 'MOJU',
  state: 'Pará',
  phone: '91 99916-1022',
  cnpj: '08.242.838/0001-01',
  state_registration: '15.257.811-0',
  corporate_name: 'NOVA ERA INDUSTRIA COMERCIO EXPORTAÇÃO DE MADEIRAS LIMITADA me'
)

# CENTRO DE CUSTO

accountplan_1=AccountPlan.create(name:"Receitas Operacionais")
accountplan_2=AccountPlan.create(name:"Despesas Funcionais")
accountplan_3=AccountPlan.create(name:"Despesas Tributárias")
accountplan_4=AccountPlan.create(name:"Despesas Bancárias")
accountplan_5=AccountPlan.create(name:"Compra de Mercadorias")
accountplan_6=AccountPlan.create(name:"Despesas não operacionais")
accountplan_7=AccountPlan.create(name:"Obrigações Sociais")
accountplan_8=AccountPlan.create(name:"Receitas Finaceiras")
accountplan_9=AccountPlan.create(name:"Despesas com Funcionários")
accountplan_10=AccountPlan.create(name:"Despesas Administrativas")
accountplan_11=AccountPlan.create(name:"Despesas com Investimentos")
accountplan_12=AccountPlan.create(name:"Despesas para imobilizado")
accountplan_13=AccountPlan.create(name:"Despesas com Vendas")

# PLANO DE CUSTO

Expense.create(account_plan_id:accountplan_1.id, name:"VENDAS DE MERCADORIAS")
Expense.create(account_plan_id:accountplan_5.id, name:"COMPRA DE PRODUTOS PARA REVENDA")
Expense.create(account_plan_id:accountplan_2.id, name:"AGUA")
Expense.create(account_plan_id:accountplan_2.id, name:"TELEFONE")
Expense.create(account_plan_id:accountplan_2.id, name:"ALUGUEL")
Expense.create(account_plan_id:accountplan_4.id, name:"EMPRESTIMOS")
Expense.create(account_plan_id:accountplan_13.id, name:"FRETES NA ENTREGA")
Expense.create(account_plan_id:accountplan_2.id, name:"ESTIVAS")


# VIGAS
produto1 = Product.create(name: 'VIGA 8X18', unity: 'M', sale_price: 65, purchase_price: 27.46)

produto2 = Product.create(name: 'VIGA 6X12 2,5M', unity: 'PCA', sale_price: 60, purchase_price: 42)
produto3 = Product.create(name: 'VIGA 6X12 3,0M', unity: 'PCA', sale_price: 72, purchase_price: 50.40)
produto4 = Product.create(name: 'VIGA 6X12 3,5M', unity: 'PCA', sale_price: 84, purchase_price: 58.80)
produto5 = Product.create(name: 'VIGA 6X12 4,0M', unity: 'PCA', sale_price: 96, purchase_price: 67.20)
produto6 = Product.create(name: 'VIGA 6X12 4,5M', unity: 'PCA', sale_price: 108, purchase_price: 75.60)
produto7 = Product.create(name: 'VIGA 6X12 5,0M', unity: 'PCA', sale_price: 120, purchase_price: 84)
produto8 = Product.create(name: 'VIGA 6X12 5,5M', unity: 'PCA', sale_price: 132, purchase_price: 92.40)
produto9 = Product.create(name: 'VIGA 6X12 6,0M', unity: 'PCA', sale_price: 144, purchase_price: 100.80)
produto10 = Product.create(name: 'VIGA 6X12 6,5M', unity: 'PCA', sale_price: 156, purchase_price: 109.20)
produto11 = Product.create(name: 'VIGA 6X12 7,0M', unity: 'PCA', sale_price: 168, purchase_price: 117.60)
produto12 = Product.create(name: 'VIGA 6X12 7,5M', unity: 'PCA', sale_price: 180, purchase_price: 126)
produto13 = Product.create(name: 'VIGA 6X12 8,0M', unity: 'PCA', sale_price: 192, purchase_price: 134)
produto14 = Product.create(name: 'VIGA 6X12 8,5M', unity: 'PCA', sale_price: 204, purchase_price: 0.0)
produto15 = Product.create(name: 'VIGA 6X12 9,0M', unity: 'PCA', sale_price: 216, purchase_price: 0.0)
produto16 = Product.create(name: 'VIGA 6X12 9,5M', unity: 'PCA', sale_price: 228, purchase_price: 0.0)

# CAIBRO
produto0 = Product.create(name: 'CAIBRO 1,0M - CACHORRO', unity: 'PCA', sale_price: 7, purchase_price: 5)

produto17 = Product.create(name: 'CAIBRO 3,5X6 2,5M', unity: 'PCA', sale_price: 17.50, purchase_price: 12.25)
produto18 = Product.create(name: 'CAIBRO 3,5X6 3,0M', unity: 'PCA', sale_price: 21, purchase_price: 14.70)
produto19 = Product.create(name: 'CAIBRO 3,5X6 3,5M', unity: 'PCA', sale_price: 24.50, purchase_price: 17.15)
produto20 = Product.create(name: 'CAIBRO 3,5X6 4,0M', unity: 'PCA', sale_price: 28, purchase_price: 19.60)
produto21 = Product.create(name: 'CAIBRO 3,5X6 4,5M', unity: 'PCA', sale_price: 31.50, purchase_price: 22.05)
produto22 = Product.create(name: 'CAIBRO 3,5X6 5,0M', unity: 'PCA', sale_price: 35, purchase_price: 24.50)
produto23 = Product.create(name: 'CAIBRO 3,5X6 5,5M', unity: 'PCA', sale_price: 38.50, purchase_price: 26.95)
produto24 = Product.create(name: 'CAIBRO 3,5X6 6,0M', unity: 'PCA', sale_price: 42, purchase_price: 29.40)
produto25 = Product.create(name: 'CAIBRO 3,5X6 6,5M', unity: 'PCA', sale_price: 45.50, purchase_price: 31.45)
produto26 = Product.create(name: 'CAIBRO 3,5X6 7,0M', unity: 'PCA', sale_price: 49, purchase_price: 34.30)
produto27 = Product.create(name: 'CAIBRO 3,5X6 7,5M', unity: 'PCA', sale_price: 52.50, purchase_price: 36.75)
produto28 = Product.create(name: 'CAIBRO 3,5X6 8,0M', unity: 'PCA', sale_price: 56, purchase_price: 0.0)
produto29 = Product.create(name: 'CAIBRO 3,5X6 8,5M', unity: 'PCA', sale_price: 59.50, purchase_price: 0.0)

# FRECHAL
produto30 = Product.create(name: 'FRECHAL 6X6', unity: 'M', sale_price: 12, purchase_price: 8.40)

# RIPA
produto31 = Product.create(name: 'RIPA 1,2X5', unity: 'DZ', sale_price: 80, purchase_price: 48)

# VIGAS
Inventory.create(product_id: produto1.id, quantity: 0.0) # SEM ESTOQUE

Inventory.create(product_id: produto2.id, quantity: 10)
Inventory.create(product_id: produto3.id, quantity: 43)
Inventory.create(product_id: produto4.id, quantity: 23)
Inventory.create(product_id: produto5.id, quantity: 29)
Inventory.create(product_id: produto6.id, quantity: 54)
Inventory.create(product_id: produto7.id, quantity: 32)
Inventory.create(product_id: produto8.id, quantity: 15)
Inventory.create(product_id: produto9.id, quantity: 19)
Inventory.create(product_id: produto10.id, quantity: 22)
Inventory.create(product_id: produto11.id, quantity: 14)
Inventory.create(product_id: produto12.id, quantity: 20)
Inventory.create(product_id: produto13.id, quantity: 2)
Inventory.create(product_id: produto14.id, quantity: 0)
Inventory.create(product_id: produto15.id, quantity: 0)
Inventory.create(product_id: produto16.id, quantity: 0.0) # SEM ESTOQUE

Inventory.create(product_id: produto0.id, quantity: 0.0) # SEM ESTOQUE

Inventory.create(product_id: produto17.id, quantity: 140)
Inventory.create(product_id: produto18.id, quantity: 105)
Inventory.create(product_id: produto19.id, quantity: 320)
Inventory.create(product_id: produto20.id, quantity: 497)
Inventory.create(product_id: produto21.id, quantity: 150)
Inventory.create(product_id: produto22.id, quantity: 570)
Inventory.create(product_id: produto23.id, quantity: 226)
Inventory.create(product_id: produto24.id, quantity: 180)
Inventory.create(product_id: produto25.id, quantity: 130)
Inventory.create(product_id: produto26.id, quantity: 150)
Inventory.create(product_id: produto27.id, quantity: 128)
Inventory.create(product_id: produto28.id, quantity: 53)

Inventory.create(product_id: produto29.id, quantity: 0.0)
Inventory.create(product_id: produto30.id, quantity: 555.55)
Inventory.create(product_id: produto31.id, quantity: 1338.77)

puts('Seed Completo!')
