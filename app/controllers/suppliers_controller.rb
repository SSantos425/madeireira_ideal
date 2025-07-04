class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.order(created_at: :asc)
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      redirect_to suppliers_path, notice: 'Fornecedor Cadastrado com Sucesso !!!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def update
    @supplier = Supplier.find(params[:id])
    if @supplier.update(supplier_params)
      redirect_to suppliers_path, notice: 'Fornecedor Atualizado com Sucesso !!!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    @supplier = Supplier.find(params[:id])
  end

  def destroy
    @supplier.destroy
    redirect_to suppliers_path, notice: 'Fornecedor Removido com Sucesso !!!'
  end

  private

  def supplier_params
    params.require(:supplier).permit(
      :name,
      :cep,
      :address,
      :number,
      :complement,
      :district,
      :city,
      :state,
      :phone,
      :cnpj,
      :state_registration,
      :corporate_name
    )
  end
end
