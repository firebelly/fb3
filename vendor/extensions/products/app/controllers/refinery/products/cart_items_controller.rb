module Refinery
  module Products
    class CartItemsController < ::ApplicationController

      before_action :get_cart
      
      def destroy
        CartItem.delete(params[:id])
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

    end
  end
end