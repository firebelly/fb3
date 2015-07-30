module Refinery
  module Products
    class CartsController < ::ApplicationController

      before_filter :get_cart

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
      end
      
      def update
        @cart.update(cart_params)
        # unless params[:items].empty?
        #   params[:items].each do |item|
        #     i = CartItem.find(item[:id])
        #     unless i.nil?
        #       i.update(quantity: item[:quantity])
        #     end
        #   end
        # end
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

      def get_cart
        @cart = Cart.find_or_create_by(session_id: session.id)
      end

    private
  
      def cart_params
        params.require(:cart).permit(:session_id, cart_items_attributes: [ :id, :quantity, :product_id, :price ])
      end

    end
  end
end