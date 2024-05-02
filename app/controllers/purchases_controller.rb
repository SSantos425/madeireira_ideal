class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.all
  end

  def new
    @purchase = Purchase.new
  end

  def create
    @purchase = Purchase.new(purchase_params)
    @purchase.update(purchase_type: 1)

    if @purchase.save
      redirect_to purchases_path
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show
    @purchase = Purchase.find(params[:id])
    @products = Product.all
    @purchase_lists = PurchaseList.all
  end


  def include_products
    purchase_id = params[:purchase_id].to_i
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_f

    purchase_list = PurchaseList.new(purchase_id:, product_id:, quantity:)
    purchase_list.save

    @purchase_lists = PurchaseList.all
    @products = Product.all
    @purchase = Purchase.find_by(id: purchase_id)
    render turbo_stream: turbo_stream.update('purchaselist', partial: 'purchases/purchase_cart',
                                                             locals: { purchase: @purchase })
  end


  def buy_purchaselist_cart
    purchase_id = params[:purchase_id]
    total_value = params[:total_value].to_f
    data = params[:data]

    purchase_lists = PurchaseList.where(purchase_id:)

    cash_register = CashRegister.last

    @purchase_lists = PurchaseList.all
    @products = Product.all

    @purchase = Purchase.find_by(id: purchase_id)
    @purchase.update(purchase_type: 0)

    purchase_lists.each do |purchase_list|
      inventory = Inventory.find_by(product_id: purchase_list.product.id)
      inventory.update(quantity: inventory.quantity + purchase_list.quantity)
    end

    cash_register.update(balance: cash_register.balance - total_value)
    CashRegisterList.create(cash_register_id: cash_register.id, date:data, balance: total_value,
                            note: 'Compra de Mercadorias para Revenda', cash_register_type: 0)
    render turbo_stream: turbo_stream.update('purchaselist', partial: 'purchases/purchase_cart_finished',
                                                             locals: { purchase: @purchase })
  end


  def update_item_purchaselist_cart
    purchase_list_id = params[:purchase_list]
    purchase_id = params[:purchase_id].to_i
    quantity = params[:quantity].to_f

    @purchase = Purchase.find_by(id: purchase_id)
    @purchase_lists = PurchaseList.all
    @products = Product.all

    current_purchaselist = PurchaseList.find_by(id: purchase_list_id)
    current_purchaselist.update(quantity:)

    render turbo_stream: turbo_stream.update('purchaselist',
                                             partial: 'purchases/purchase_cart', locals: { purchaselist: @purchase_lists })
  end


  def remove_item_purchaselist_cart
    purchase_list_id = params[:purchase_list]
    purchase_id = params[:purchase_id].to_i

    @purchase = Purchase.find_by(id: purchase_id)

    PurchaseList.find_by(id: purchase_list_id).destroy

    @purchase_lists = PurchaseList.all
    @products = Product.all
    render turbo_stream: turbo_stream.update('purchaselist', partial: 'purchases/purchase_cart',
                                                             locals: { purchase: @purchase })
  end

  def purchase_discount_or_addition

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

  private

  def purchase_params
    params.require(:purchase).permit(
      :supplier_id,
      :nota_number,
      :serie,
      :issue_date,
      :receipt_date,
      :total_nota,
      :total_products,
      :discount,
      :additon,
      :tax,
      :shipping,
      :purchase_type
    )
  end
end
