Rails.application.routes.draw do
  root 'cash_registers#new'
  devise_for :users

  resources :products
  resources :clients
  resources :suppliers
  resources :inventories
  resources :purchases
  resources :cash_registers
  resources :sales, only: [:index]
  resources :carts, only: [:index]
  resources :bills, only: [:index]

  #PRODUCTS
  patch "adjust_all_sale_purchase_prices", to: "products#adjust_all_sale_purchase_prices", as: "adjust_all_sale_purchase_prices"
  patch "adjust_all_purchase_prices", to: "products#adjust_all_purchase_prices", as:"adjust_all_purchase_prices"
  patch "single_item_price_adjust", to: "products#single_item_price_adjust", as:"single_item_price_adjust"


  #SALES
  get "sales_data", to: "sales#sales_data", as: "sales_data"
  get "show_sale", to: "sales#show_sale", as:"show_sale"
  get 'download', to: 'sales#download_pdf', as: 'download_sales_pdf'
  get 'all_sales', to: 'sales#all_sales_download_pdf', as: 'all_sales_download_pdf'
  get 'period_sales', to: 'sales#period_sales_download_pdf', as: 'period_sales_download_pdf'


  # PURCHASE
  post 'include_products', to: 'purchases#include_products', as: 'include_products'
  post 'buy_purchaselist_cart', to: 'purchases#buy_purchaselist_cart', as: 'buy_purchaselist_cart'
  post 'remove_item_purchaselist_cart', to: 'purchases#remove_item_purchaselist_cart', as: 'remove_item_purchaselist_cart'
  post 'update_item_purchaselist_cart', to: 'purchases#update_item_purchaselist_cart', as: 'update_item_purchaselist_cart'
  post 'purchase_discount_or_addition', to: 'purchases#purchase_discount_or_addition', as: 'purchase_discount_or_addition'
  post 'foward_purchase', to: 'purchases#foward_purchase', as: 'foward_purchase'
  post 'filter_purchase', to: 'purchases#filter_purchase', as: 'filter_purchase'


  # CASH_REGISTER
  post 'replenishment_or_withdrawl_cash_register', to: 'cash_registers#replenishment_or_withdrawl_cash_register', as: 'replenishment_or_withdrawl_cash_register'
  post 'close_cash_register', to: 'cash_registers#close_cash_register', as: 'close_cash_register'
  get 'show_cash_registers', to: 'cash_registers#show_cash_registers', as: 'show_cash_registers'




 # CART
 post 'cart_orderable', to: 'carts#cart_orderable', as: 'cart_orderable'
 post 'update_orderable_item', to: 'carts#update_orderable_item', as: 'update_orderable_item'
 post 'remove_orderable_item', to: 'carts#remove_orderable_item', as: 'remove_orderable_item'
 get 'show/:cart_id/:client_id', to: 'carts#show', as: 'show'
 get 'sell_cart/:cart_balance', to: 'carts#sell_cart', as: 'sell_cart'
 post 'foward_sell_cart', to: 'carts#foward_sell_cart', as: 'foward_sell_cart'
 get 'new_cart', to: 'carts#new_cart', as: 'new_cart'
 get 'search_product', to: 'carts#search_product', as: 'search_product'
 post 'filter', to: 'carts#filter', as: 'filter'
 post 'orderable_discount_or_addition', to: 'carts#orderable_discount_or_addition', as: 'orderable_discount_or_addition'




 #bills

 post 'receive_bills', to: 'bills#receive_bills', as: 'receive_bills'
 post 'payment_bills', to: 'bills#payment_bills', as: 'payment_bills'

 get 'bills_payment_index', to: 'bills#bills_payment_index', as: 'bills_payment_index'



end
