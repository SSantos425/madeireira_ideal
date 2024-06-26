class CartsController < ApplicationController
  def index
    @cart = Cart.last
  end

  def new_cart
    @cart = Cart.new(balance: nil, discount: 0, addition: 0, date: Date.today)

    if @cart.save
      redirect_to carts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # products_name = params[:products_name]
    @cart = Cart.find(params[:cart_id])
    @client = Client.find(params[:client_id])

    # @products_name = Product.where("name LIKE ?", "%#{products_name}%")

    @products = Product.all
    @orderables = Orderable.all
  end

  def cart_orderable
    product_id = params[:product_id]
    quantity = params[:quantity]

    @cart = Cart.last
    @client = Client.find_by(id: params[:client_id])

    current_orderable = @cart.orderables.find_by(product_id:)

    if current_orderable.nil?
      Orderable.create(product_id:, cart_id: @cart.id, client_id: @client.id, quantity:)
    else
      current_orderable.update(quantity:)
    end

    @orderables = Orderable.all
    @products = Product.all

    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
  end

  def remove_orderable_item
    orderable_id = params[:orderable_id]

    Orderable.find_by(id: orderable_id).destroy

    @cart = Cart.last
    @orderables = Orderable.all
    @products = Product.all
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
    @orderables = Orderable.all
    @products = Product.all
    @client = Client.find_by(id: params[:client_id])
    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
  end

  def sell_cart
    cart_balance = params[:cart_balance]
    cart_last = Cart.last
    cart_last.update(balance: cart_balance)

    cart_orderables = Orderable.where(cart_id: cart_last.id)
    cart_orderables.each do |cart_orderable|
      inventory = Inventory.find_by(product_id: cart_orderable.product.id)
      inventory.update(quantity: inventory.quantity - cart_orderable.quantity)
    end

    # atualiza o valor do caixa
    CashRegister.last.update(balance: CashRegister.last.balance + cart_last.balance)

    # cria um registro no caixa
    CashRegisterList.create(cash_register_id: CashRegister.last.id, date: Date.today, balance: cart_last.balance,
                            note: 'Venda de Mercadoria(Madeira)', cash_register_type: 1)

    redirect_to cash_registers_path
  end

  def orderable_discount_or_addition
    quantity = params[:quantity].to_f
    @cart = Cart.find(params[:cart_id])

    @orderables = Orderable.all
    @products = Product.all
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

    # 0 contas a pagar
    # 1 contas a receber

    bill = BillsReceive.create(down_payment:, total_value: cart_last.balance, cart_id: cart_last.id, obs:obs)
    bill.update(remaining_payment:bill.total_value - bill.down_payment)
    cart_orderables = Orderable.where(cart_id: cart_last.id)
    cart_orderables.each do |cart_orderable|
      inventory = Inventory.find_by(product_id: cart_orderable.product.id)
      inventory.update(quantity: inventory.quantity - cart_orderable.quantity)
    end

    # atualiza o valor do caixa
    CashRegister.last.update(balance: CashRegister.last.balance + cart_last.balance)

    # cria um registro no caixa
    CashRegisterList.create(cash_register_id: CashRegister.last.id, date: Date.today, balance: down_payment,
                            note: "Venda de Mercadoria(Madeira) a Prazo, valor de entrada R$:#{down_payment}, valor total R$:#{cart_last.balance}", cash_register_type: 1)

    redirect_to cash_registers_path
  end
end
