Rails.application.routes.draw do
  devise_for :users

  resources :products, only: [:index, :edit, :new, :create, :destroy]

  resources :inventorylists #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :vendas #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :vendalists #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :cartlist #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :cartlist_orderables #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :fornecedores #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :clientes #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :wallets #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :compras #COLOCAR O ONLY AQUI PRA NAO FICAR UMAS ROTAS AVULSAS
  resources :list_wallets
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

end
