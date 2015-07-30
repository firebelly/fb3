module Refinery
  module Products
    class Cart < Refinery::Core::BaseModel
      self.table_name = 'refinery_products_carts'

      has_many :items, :class_name => "Refinery::Products::CartItem", :dependent => :destroy
      
      def add_item(product)
        price = product.price

        # If option, only find cart item with that particular option and product
        if item = self.items.find(product_id: product.id)
          item.quantity += 1
          item.save
        else
          self.items.create(:product_id => product.id, :price => price, :quantity => 1)
        end
      end
      
      def subtotal
        unless self.items.empty?
          self.items.map(&:subtotal).reduce(:+)
        else
          return 0
        end
      end
  
    end
  end
end
