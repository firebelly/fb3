class CreateProductsCartItems < ActiveRecord::Migration
  def change
    create_table :refinery_products_cart_items do |t|
      t.integer :product_id
      t.integer :quantity
      t.decimal :price
      t.integer :cart_id

      t.timestamps
    end
  end
end
