class ClientsController < ApplicationController
  def index
    @clients = Client.all
  end

  def new
    @client = Client.new
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @client = Client.find(params[:id])
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])

    if @client.update(client_params)
      redirect_to clients_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    redirect_to clients_path
  end

  private

  def client_params
    params.require(:client).permit(:customer_type, :name, :cpf,
                                    :cep, :address, :district,
                                    :city, :state,
                                    :cnpj, :state_registration,
                                    :municipal_registration, :business_sector,
                                    :ibge_code,
                                    :notes,:number)
  end
end
