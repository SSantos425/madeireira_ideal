class ProductsController < ApplicationController
  def index
    @products = Product.order(created_at: :asc)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      Inventory.create(product_id: @product.id, quantity: 0.0)
      redirect_to products_path, notice: 'Produto adicionado com sucesso !!'
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
      redirect_to products_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path
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

    redirect_to products_path, notice: 'Preços ajustados com sucesso.'
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

  def adjust_purchase_prices
    purchase_percentage = params[:purchase_percentage].to_f
    return unless purchase_percentage.present?

    Product.all.each do |product|
      if params[:increase_viga_purchase_percentage]
        product.increase_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('VIGA')
      elsif params[:decrease_viga_purchase_percentage]
        product.decrease_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('VIGA')
      elsif params[:increase_caibro_purchase_percentage]
        product.increase_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('CAIBRO')
      elsif params[:decrease_caibro_purchase_percentage]
        product.decrease_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('CAIBRO')
      elsif params[:increase_frechal_purchase_percentage]
        product.increase_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('FRECHAL')
      elsif params[:decrease_frechal_purchase_percentage]
        product.decrease_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('FRECHAL')
      elsif params[:increase_ripa_purchase_percentage]
        product.increase_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('RIPA')
      elsif params[:decrease_ripa_purchase_percentage]
        product.decrease_purchase_price_by_percentage(purchase_percentage) if product.name.start_with?('RIPA')
      end
      product.save if product.changed?
    end

    redirect_to products_path, notice: 'Preços ajustados com sucesso.'
  end

  def adjust_sale_prices
    sale_percentage = params[:sale_percentage].to_f
    return unless sale_percentage.present?

    Product.all.each do |product|
      if params[:increase_viga_sale_percentage]
        product.increase_sale_price_by_percentage(sale_percentage) if product.name.start_with?('VIGA')
      elsif params[:decrease_viga_sale_percentage]
        product.decrease_sale_price_by_percentage(sale_percentage) if product.name.start_with?('VIGA')
      elsif params[:increase_caibro_sale_percentage]
        product.increase_sale_price_by_percentage(sale_percentage) if product.name.start_with?('CAIBRO')
      elsif params[:decrease_caibro_sale_percentage]
        product.decrease_sale_price_by_percentage(sale_percentage) if product.name.start_with?('CAIBRO')
      elsif params[:increase_frechal_sale_percentage]
        product.increase_sale_price_by_percentage(sale_percentage) if product.name.start_with?('FRECHAL')
      elsif params[:decrease_frechal_sale_percentage]
        product.decrease_sale_price_by_percentage(sale_percentage) if product.name.start_with?('FRECHAL')
      elsif params[:increase_ripa_sale_percentage]
        product.increase_sale_price_by_percentage(sale_percentage) if product.name.start_with?('RIPA')
      elsif params[:decrease_ripa_sale_percentage]
        product.decrease_sale_price_by_percentage(sale_percentage) if product.name.start_with?('RIPA')
      end
      product.save if product.changed?
    end

    redirect_to products_path, notice: 'Preços ajustados com sucesso.'
  end

  private

  def product_params
    params.require(:product).permit(:name, :unity, :sale_price, :purchase_price)
  end
end
