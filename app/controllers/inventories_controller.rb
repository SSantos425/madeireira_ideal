class InventoriesController < ApplicationController
  def index
    @inventories = Inventory.order(created_at: :asc)  # Ordena pela data de criação em ordem crescente
  end

  def edit
    @inventory = Inventory.find(params[:id])
  end

  def update
    @inventory = Inventory.find(params[:id])

    if @inventory.update(inventory_params)
      redirect_to inventories_path, notice: "Produto Atualizado com Sucesso"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # REVER ESSE METODO
  def adicionar_ao_estoque
    user_id = params[:user_id]
    produto_id = params[:produto_id]
    quantity = params[:quantity].to_f

    inventory_list = Inventorylist.find_by(user_id:, produto_id:)

    if inventory_list.nil?
      inventory_list = Inventorylist.new(user_id:, produto_id:, quantity:)
      inventory_list.save
      puts("#{inventory_list.errors.full_messages}")
      flash[:success] = 'Produto adicionado ao estoque com sucesso!'
      redirect_to root_path

    else
      inventory_list.update(quantity: inventory_list.quantity + quantity)
      flash[:notice] = 'Produto ATUALIZADO com sucesso!'

      redirect_to root_path
    end
  end

  private

  def inventory_params
    params.require(:inventory).permit(:product_id, :quantity)
  end
end
