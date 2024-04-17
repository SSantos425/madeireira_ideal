Rails.application.routes.draw do
  root 'cash_registers#new'
  devise_for :users

  resources :products, only: [:index, :edit, :new, :create, :destroy]
  resources :clients
  resources :suppliers
  resources :inventories
  resources :purchases
  resources :cash_registers
  resources :sales
  #resources :cartlist
  #resources :cartlist_orderables

  resources :carts, only: [:index]

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
  get 'show_cash_registers', to: 'cash_registers#show_cash_registers', as: 'show_cash_registers'




 # CART
 post 'cart_orderable', to: 'carts#cart_orderable', as: 'cart_orderable'
 post 'update_orderable_item', to: 'carts#update_orderable_item', as: 'update_orderable_item'
 post 'remove_orderable_item', to: 'carts#remove_orderable_item', as: 'remove_orderable_item'
 get 'show/:cart_id/:client_id', to: 'carts#show', as: 'show'
 get 'sell_cart/:cart_balance', to: 'carts#sell_cart', as: 'sell_cart'
 get 'new_cart', to: 'carts#new_cart', as: 'new_cart'


end
