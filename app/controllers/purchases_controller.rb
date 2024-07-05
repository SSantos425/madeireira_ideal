class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.order(created_at: :asc)
  end

  def new
    @purchase = Purchase.new
    @show_form = false
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
    @products = Product.order(created_at: :asc)
    @purchase_lists = PurchaseList.order(created_at: :asc)
  end

  def include_products
    purchase_id = params[:purchase_id].to_i
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_f

    purchase_list = PurchaseList.new(purchase_id:, product_id:, quantity:)
    purchase_list.save
    product = Product.find_by(id:product_id)
    @purchase_lists = PurchaseList.order(created_at: :asc)
    if product.name.present?
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
        @products = Product.all.order(created_at: :asc)
      end
    else
      @products = Product.all.order(created_at: :asc)
    end
    @purchase = Purchase.find_by(id: purchase_id)
    render turbo_stream: turbo_stream.update('purchaselist', partial: 'purchases/purchase_cart',
                                                             locals: { purchase: @purchase, products:@products })
  end

  def buy_purchaselist_cart
    purchase_id = params[:purchase_id]
    total_value = params[:total_value].to_f
    data = params[:data]

    purchase_lists = PurchaseList.where(purchase_id:)

    cash_register = CashRegister.last

    @purchase_lists = PurchaseList.order(created_at: :asc)
    @products = Product.order(created_at: :asc)

    @purchase = Purchase.find_by(id: purchase_id)
    @purchase.update(purchase_type: 0)

    purchase_lists.each do |purchase_list|
      inventory = Inventory.find_by(product_id: purchase_list.product.id)
      inventory.update(quantity: inventory.quantity + purchase_list.quantity)
    end

    cash_register.update(balance: cash_register.balance - total_value)
    CashRegisterList.create(cash_register_id: cash_register.id, date: data, balance: total_value,
                            note: 'Compra de Mercadorias para Revenda', cash_register_type: 0)

    render turbo_stream: turbo_stream.update('purchaselist', partial: 'purchases/purchase_cart_finished',
                                                             locals: { purchase: @purchase })
  end

  def update_item_purchaselist_cart
    purchase_list_id = params[:purchase_list]
    purchase_id = params[:purchase_id].to_i
    quantity = params[:quantity].to_f

    @purchase = Purchase.find_by(id: purchase_id)
    @purchase_lists = PurchaseList.order(created_at: :asc)
    @products = Product.order(created_at: :asc)

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

    @purchase_lists = PurchaseList.order(created_at: :asc)
    @products = Product.order(created_at: :asc)
    render turbo_stream: turbo_stream.update('purchaselist', partial: 'purchases/purchase_cart',
                                                             locals: { purchase: @purchase })
  end

  def purchase_discount_or_addition
    quantity = params[:quantity].to_f
    @purchase = Purchase.find_by(id: params[:purchase_id])

    @orderables = Orderable.order(created_at: :asc)
    @products = Product.order(created_at: :asc)
    @purchase_lists = PurchaseList.order(created_at: :asc)

    if params[:discount]
      @purchase.update(discount: quantity)
      render turbo_stream: turbo_stream.update('purchaselist',partial: 'purchases/purchase_cart', locals: { purchaselist: @purchase_lists })
    elsif params[:addition]
      @purchase.update(additon: quantity)
      render turbo_stream: turbo_stream.update('purchaselist',partial: 'purchases/purchase_cart', locals: { purchaselist: @purchase_lists })
    end
  end

  def foward_purchase
    purchase_id = params[:purchase_id]
    total_value = params[:total_value].to_f
    down_payment = params[:down_payment].to_f

    bill_payment = BillsPayment.create(down_payment:, total_value:, purchase_id:)
    bill_payment.update(remaining_payment: bill_payment.total_value - bill_payment.down_payment)

    purchase_lists = PurchaseList.where(purchase_id:)
    purchase_lists.each do |purchase_list|
      inventory = Inventory.find_by(product_id: purchase_list.product.id)
      inventory.update(quantity: inventory.quantity + purchase_list.quantity)
    end
    cash_register = CashRegister.last
    cash_register.update(balance: cash_register.balance - down_payment)
    # cria um registro no caixa
    CashRegisterList.create(cash_register_id: CashRegister.last.id, date: Date.today, balance: down_payment,
                            note: "Compra de Mercadoria(Madeira) a Prazo, valor de entrada R$:#{down_payment}, valor total R$:#{total_value}", cash_register_type: 2)

    purchase = Purchase.find_by(id: purchase_id)
    purchase.update(purchase_type: 0)

    redirect_to cash_registers_path
  end

  def filter_purchase
    product_name=params[:product_name]
    @purchase = Purchase.find_by(id: params[:purchase_id])

    # Lógica para filtrar produtos baseados no nome
    if product_name.present?
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
        @products = Product.all.order(created_at: :asc)
      end
    else
      @products = Product.all.order(created_at: :asc)
    end
    @purchase_lists = PurchaseList.order(created_at: :asc)
    render turbo_stream: turbo_stream.update('purchaselist',partial: 'purchases/purchase_cart', locals: { purchaselist: @purchase_lists, products:@products })
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
