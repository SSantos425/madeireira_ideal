class ProductsController < ApplicationController
  def index
    @products = Product.order(created_at: :asc)
    @grouped_products = Product.order(created_at: :asc).group_by do |product|
      if product.name.include?("VIGA 6X12")
        "VIGAS 6x12"
      elsif product.name.include?("VIGA 8X18")
        "VIGAS 8x18"
      elsif product.name.include?("CAIBRO 3,5X6")
        "CAIBRO 3,5x6"
      elsif product.name.include?("CAIBRO 1,0M")
        "CAIBRO CURTO"
      elsif product.name.include?("FRECHAL")
        "FRECHAL"
      elsif product.name.include?("RIPA")
        "RIPA"
      else
        "Outros"
        end
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      Inventory.create(product_id: @product.id, quantity: 0.0)
      redirect_to products_path, notice: 'Produto cadastrado com sucesso !!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(product_params)
      redirect_to products_path, notice: 'Produto atualizado com sucesso !!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path, notice: 'Produto Excluido com sucesso !!'
  end

  def adjust_all_sale_purchase_prices
    value = params[:sale_percentage].to_f

    if params[:increase_sale_percentage]
      Product.all.each do |product|
        product.increase_sale_price_by_percentage(value)
        product.save
      end
    elsif params[:decrease_sale_percentage]
      Product.all.each do |product|
        product.decrease_sale_price_by_percentage(value)
        product.save
      end
    elsif params[:increase_purchase_percentage]
      Product.all.each do |product|
        product.increase_purchase_price_by_percentage(value)
        product.save
      end
    elsif params[:decrease_purchase_percentage]
      Product.all.each do |product|
        product.decrease_purchase_price_by_percentage(value)
        product.save
      end
    end

    redirect_to products_path, notice: 'Preços ajustados com sucesso !!'
  end

  def adjust_all_purchase_prices
    purchase_percentage = params[:purchase_percentage].to_f

    if params[:increase_purchase_percentage]
      Product.all.each do |product|
        product.increase_purchase_price_by_percentage(purchase_percentage)
        product.save
      end
    elsif params[:decrease_purchase_percentage]
      Product.all.each do |product|
        product.decrease_purchase_price_by_percentage(purchase_percentage)
        product.save
      end
    end

    redirect_to products_path, notice: 'Preços ajustados com sucesso.'
  end

  def single_item_price_adjust
    adjust_percentage_value = params[:adjust_percentage_value].to_f
    discount_or_addition = params[:discount_or_addition].to_s
    purchase_or_sell = params[:purchase_or_sell].to_s
    return unless adjust_percentage_value.present?

    Product.all.each do |product|
      case purchase_or_sell
      when 'Compra'
        case discount_or_addition
        when 'Acréscimo'
          adjust_purchase_price(product, adjust_percentage_value, :increase_purchase_price_by_percentage)
        when 'Desconto'
          adjust_purchase_price(product, adjust_percentage_value, :decrease_purchase_price_by_percentage)
        end
      when 'Venda'
        case discount_or_addition
        when 'Acréscimo'
          adjust_purchase_price(product, adjust_percentage_value, :increase_sale_price_by_percentage)
        when 'Desconto'
          adjust_purchase_price(product, adjust_percentage_value, :decrease_sale_price_by_percentage)
        end
      end
      product.save if product.changed?
    end
    redirect_to products_path, notice: 'Preços ajustados com sucesso.'
  end


  private

  def adjust_purchase_price(product, percentage, method)
    case product.name
    when /^VIGA/, /^CAIBRO/, /^FRECHAL/, /^RIPA/
      product.send(method, percentage)
    end
  end

  def product_params
    params.require(:product).permit(:name, :unity, :sale_price, :purchase_price)
  end
end
