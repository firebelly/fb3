module Refinery
  module Products
    class CartsController < ::ApplicationController

      before_action :get_cart

      def index
        respond_to do |format|
          format.html do
            if request.xhr?
              render "carts/cart"
            else
              render
            end
          end
        end
      end
      
      def create
        product = Product.find(params[:product_id])
        @cart.add_item(product)
        @cart.save
        respond_to do |format|
          format.html do
            if request.xhr?
              render partial: "refinery/products/carts/cart"
            else
              redirect_to refinery.products_carts_path
            end
          end
        end
        Cart.clear_cruft # ghetto cronjob
      end
      
      def update
        @cart.update(cart_params)
        respond_to do |format|
          format.html do
            if request.xhr?
              render partial: "refinery/products/carts/cart"
            else
              redirect_to refinery.products_carts_path
            end
          end
        end
      end

    private
  
      def cart_params
        params.require(:cart).permit(:session_id, cart_items_attributes: [ :id, :quantity, :product_id, :price ])
      end

    end
  end
end