module Refinery
  module Products
    class CartItem < Refinery::Core::BaseModel
      belongs_to :product, :class_name => "Refinery::Products::Products"
      belongs_to :cart, :class_name => "Refinery::Products::Carts"
      
      def subtotal
        quantity * price
      end
      
      def to_s
        self.product.name
      end
    end
  end
end