module Refinery
  module Products
    class CartItemsController < ::ApplicationController
      
      def destroy
        CartItem.delete(params[:id])
        respond_to do |format|
          format.html do
            if request.xhr?
              @cart = Cart.find_or_create_by(session_id: session.id)
              render "carts/cart"
            else
              redirect_to carts_path
            end
          end
        end
      end

    end
  end
end