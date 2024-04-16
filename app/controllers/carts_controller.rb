class CartsController < ApplicationController
  def index
    @carts = Cart.all
  end

  def new
    @cart = Cart.new
  end

  def create
    @cart = Cart.new(balance: nil, discount: nil, addition: nil, date: Date.today)

    if @cart.save
      redirect_to carts_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @cart = Cart.find(params[:id])
    @products = Product.all
    @orderables = Orderable.all
    @client = Client.first
  end

  def cart_orderable
    product_id = params[:product_id]
    cart_id = params[:cart_id]
    @cart = Cart.find_by(id: cart_id)
    client_id = params[:client_id]
    quantity = params[:quantity]

    current_orderable = @cart.orderables.find_by(product_id: product_id)

    if current_orderable.nil? 
      Orderable.create(product_id:, cart_id:, client_id:, quantity:)
    else
      current_orderable.update(quantity:)
    end

    @orderables = Orderable.all
    @products = Product.all
    @client = Client.first

    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
  end

  def remove_orderable_item
    orderable_id = params[:orderable_id]
    
    Orderable.find_by(id: orderable_id).destroy


    cart_id = params[:cart_id]
    @cart = Cart.find_by(id: cart_id)
    @orderables = Orderable.all
    @products = Product.all
    @client = Client.first
    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
  end

  def update_orderable_item
    orderable_id = params[:orderable_id]
    quantity = params[:quantity].to_f

    orderable = Orderable.find_by(id: orderable_id)
    orderable.update(quantity:)


    cart_id = params[:cart_id]
    @cart = Cart.find_by(id: cart_id)
    @orderables = Orderable.all
    @products = Product.all
    @client = Client.first
    render turbo_stream: turbo_stream.update('cart', partial: 'carts/cart',
                                                     locals: { orderable: @orderable, cart: @cart, product: @products, client: @client })
  end
end
