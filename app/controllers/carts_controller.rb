class CartsController < ApplicationController
  def index
    @cart = Cart.last
  end

  def new_cart
    @cart = Cart.new(balance: 0, discount: 0, addition: 0, date: CashRegister.last.date)

    if @cart.save

      redirect_to carts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @cart = Cart.find(params[:cart_id])
    @client = Client.find(params[:client_id])

    @products = Product.where('name LIKE ?', 'RIPA%').order(created_at: :asc)
    @orderables = Orderable.order(created_at: :asc)
  end

  def cart_orderable
    product_id = params[:product_id]
    quantity = params[:quantity]

    @cart = Cart.last
    @client = Client.find_by(id: params[:client_id])

    current_orderable = @cart.orderables.find_by(product_id: product_id)

    if current_orderable.nil?
      if quantity.to_f > Inventory.find(product_id).quantity
        flash.now[:warning] = "Quantidade indisponivel no estoque."
      else
        Orderable.create(product_id: product_id, cart_id: @cart.id, client_id: @client.id, quantity: quantity)
        flash[:notice] = "Produto Adicionado!"
      end
    else
      current_orderable.update(quantity: quantity)
    end

    # Lógica para filtrar produtos baseados no nome
    product = Product.find(product_id)
    case
    when product.name.start_with?('VIGA')
      @products = Product.where('name LIKE ?', 'VIGA%').order(created_at: :asc)
    when product.name.start_with?('CAIBRO')
      @products = Product.where('name LIKE ?', 'CAIBRO%').order(created_at: :asc)
    when product.name.start_with?('FRECHAL')
      @products = Product.where('name LIKE ?', 'FRECHAL%').order(created_at: :asc)
    when product.name.start_with?('RIPA')
      @products = Product.where('name LIKE ?', 'RIPA%').order(created_at: :asc)
    else
      @products = Product.where('name LIKE ?', 'RIPA%').order(created_at: :asc)
    end

    @orderables = Orderable.order(created_at: :asc)
    render turbo_stream: turbo_stream.update('orderables-table-body', partial: 'carts/orderables_table_body', locals: { orderables: @orderables, cart: @cart, client: @client })
  end

  def remove_orderable_item
    orderable_id = params[:orderable_id]

    Orderable.find_by(id: orderable_id).destroy

    @cart = Cart.last
    @orderables = Orderable.order(created_at: :asc)

    product = Product.all
    case
    when product.name.start_with?('VIGA')
      @products = Product.where('name LIKE ?', 'VIGA%').order(created_at: :asc)
    when product.name.start_with?('CAIBRO')
      @products = Product.where('name LIKE ?', 'CAIBRO%').order(created_at: :asc)
    when product.name.start_with?('FRECHAL')
      @products = Product.where('name LIKE ?', 'FRECHAL%').order(created_at: :asc)
    when product.name.start_with?('RIPA')
      @products = Product.where('name LIKE ?', 'RIPA%').order(created_at: :asc)
    else
      @products = Product.where('name LIKE ?', 'RIPA%').order(created_at: :asc)
    end

    @client = Client.find_by(id: params[:client_id])
    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
  end

  def update_orderable_item
    orderable_id = params[:orderable_id]
    quantity = params[:quantity].to_f

    orderable = Orderable.find_by(id: orderable_id)
    orderable.update(quantity:)

    @cart = Cart.last
    @orderables = Orderable.order(created_at: :asc)
    @products = Product.order(created_at: :asc)
    @client = Client.find_by(id: params[:client_id])
    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
  end

  def sell_cart
    cart_balance = params[:cart_balance]
    cart_last = Cart.last
    cart_last.update(balance: cart_balance)

    expense = Expense.find_by(name:"VENDAS DE MERCADORIAS")

    cart_orderables = Orderable.where(cart_id: cart_last.id)
    if cart_orderables.empty?
      flash[:error] = "Carrinho Vazio!"
      redirect_to request.referer
    else
      cart_orderables.each do |cart_orderable|
        inventory = Inventory.find_by(product_id: cart_orderable.product.id)
        inventory.update(quantity: inventory.quantity - cart_orderable.quantity)
      end

      # atualiza o valor do caixa
      CashRegister.last.update(balance: CashRegister.last.balance + cart_last.balance)

      # cria um registro no caixa
      CashRegisterList.create(cash_register_id: CashRegister.last.id, date: CashRegister.last.date, balance: cart_last.balance,
                              note: 'Venda de Mercadoria(Madeira)', cash_register_type: 1,expense_id: expense.id)

      check_cart = Cart.where(balance: 0)
      check_cart.destroy_all
      flash[:notice] = "Venda Efetuada!"
      redirect_to new_cart_path
    end
  end

  def orderable_discount_or_addition
    quantity = params[:quantity].to_f
    @cart = Cart.find(params[:cart_id])

    @orderables = Orderable.order(created_at: :asc)
    @products = Product.order(created_at: :asc)
    @client = Client.find_by(id: params[:client_id])

    if params[:discount]
      @cart.update(discount: quantity)
      render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                       locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
    elsif params[:addition]
      @cart.update(addition: quantity)
      render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                       locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
    end
  end

  def foward_sell_cart
    cart_balance = params[:cart_balance]
    cart_last = Cart.last
    cart_last.update(balance: cart_balance)
    down_payment = params[:down_payment].to_f
    obs = params[:obs].to_s

    expense = Expense.find_by(name:"VENDAS DE MERCADORIAS")

    # 0 contas a pagar
    # 1 contas a receber

    bill = BillsReceive.create(down_payment:, total_value: cart_last.balance, cart_id: cart_last.id, obs:)
    bill.update(remaining_payment: bill.total_value - bill.down_payment)
    cart_orderables = Orderable.where(cart_id: cart_last.id)
    cart_orderables.each do |cart_orderable|
      inventory = Inventory.find_by(product_id: cart_orderable.product.id)
      inventory.update(quantity: inventory.quantity - cart_orderable.quantity)
    end

    # atualiza o valor do caixa
    CashRegister.last.update(balance: CashRegister.last.balance + cart_last.balance)

    # cria um registro no caixa
    CashRegisterList.create(cash_register_id: CashRegister.last.id, date: CashRegister.last.date, balance: down_payment,
                            note: "Venda de Mercadoria(Madeira) a Prazo, valor de entrada R$:#{down_payment}, valor total R$:#{cart_last.balance}", cash_register_type: 1, expense_id:expense.id)

    check_cart = Cart.where(balance: 0)
    check_cart.destroy_all
    redirect_to cash_registers_path
  end

  def filter
    product_name = params[:product_name]
    @client = Client.find_by(id: params[:client_id])

    # Lógica para filtrar produtos baseados no nome
    case
    when product_name.start_with?('VIGA')
      @products = Product.where('name LIKE ?', 'VIGA%').order(created_at: :asc)
    when product_name.start_with?('CAIBRO')
      @products = Product.where('name LIKE ?', 'CAIBRO%').order(created_at: :asc)
    when product_name.start_with?('FRECHAL')
      @products = Product.where('name LIKE ?', 'FRECHAL%').order(created_at: :asc)
    when product_name.start_with?('RIPA')
      @products = Product.where('name LIKE ?', 'RIPA%').order(created_at: :asc)
    else
      @products = Product.where('name LIKE ?', 'RIPA%').order(created_at: :asc)
    end

    @cart = Cart.last
    @orderables = Orderable.order(created_at: :asc)
    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderables: @orderables, cart: @cart, products: @products, client: @client })
  end
end
