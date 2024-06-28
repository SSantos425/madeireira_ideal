class SuppliersController < ApplicationController
  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      flash[:notice] = "Fornecedor adicionado com sucesso !!"
      redirect_to suppliers_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @supplier = Supplier.find(params[:id])
  end

  def update
    if @supplier.update(supplier_params)
      flash[:notice] = "Fornecedor atualizado com sucesso !!"
      redirect_to suppliers_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def show
  end

  def destroy
    @supplier.destroy
    flash[:notice] = "Fornecedor Removido com Sucesso !!"
    redirect_to suppliers_path
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
