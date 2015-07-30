module Refinery
  module Products
    class CartItem < Refinery::Core::BaseModel
      belongs_to :product, class_name: "::Refinery::Products::Product"
      belongs_to :cart, class_name: "::Refinery::Products::Cart"
      
      def subtotal
        quantity * price
      end
      
      def to_s
        product.title
      end
    end
  end
end