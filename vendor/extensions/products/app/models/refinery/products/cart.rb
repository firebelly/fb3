module Refinery
  module Products
    class Cart < Refinery::Core::BaseModel
      self.table_name = 'refinery_products_carts'

      has_many :cart_items, class_name: "::Refinery::Products::CartItem", :dependent => :destroy
      
      accepts_nested_attributes_for :cart_items, allow_destroy: true

      def add_item(product)
        price = product.price

        if cart_item = cart_items.where(product_id: product.id).first
          cart_item.quantity += 1
          cart_item.save
        else
          cart_items.create(product_id: product.id, price: price, quantity: 1)
        end
      end
      
      def subtotal
        unless cart_items.empty?
          cart_items.map(&:subtotal).reduce(:+)
        else
          return 0
        end
      end
  
    end
  end
end
