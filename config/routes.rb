Rails.application.routes.draw do
  root 'cash_registers#new'
  devise_for :users

  resources :products, only: [:index, :edit, :new, :create, :destroy]
  resources :clients
  resources :suppliers
  resources :inventories
  resources :purchases
  resources :cash_registers

  resources :inventorylists #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :vendas #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :vendalists #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :cartlist #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :cartlist_orderables #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  

  resources :wallets #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :compras #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :list_wallets
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")


  # PURCHASE
  post 'include_products', to: 'purchases#include_products', as: 'include_products'
  post 'buy_purchaselist_cart', to: 'purchases#buy_purchaselist_cart', as: 'buy_purchaselist_cart'
  post 'remove_item_purchaselist_cart', to: 'purchases#remove_item_purchaselist_cart', as: 'remove_item_purchaselist_cart'
  post 'update_item_purchaselist_cart', to: 'purchases#update_item_purchaselist_cart', as: 'update_item_purchaselist_cart'
  get '/compras_cliente/:cliente_id', to: 'compras#compras_cliente', as: 'compras_cliente'

  
  # CASH_REGISTER
  post 'cash_replenishment', to: 'cash_registers#cash_replenishment', as: 'cash_replenishment'
  post 'withdraw_cash_register', to: 'cash_registers#withdraw_cash_register', as: 'withdraw_cash_register'
  post 'close_cash_register', to: 'cash_registers#close_cash_register', as: 'close_cash_register'







end
