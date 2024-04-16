class SalesController < ApplicationController
    def index
        @client = Client.find_by(id: params[:client_id])
        @products = Product.all
    end
end
