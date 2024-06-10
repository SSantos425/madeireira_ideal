class SalesController < ApplicationController
    def index
        @orderables = Orderable.all
        @cart = Cart.last
    end

    def sales_data
        @carts = Cart.where(date: params[:date])
    end

    def show_sale
        @cart = Cart.find_by(id:params[:cart_id])
    end
end
