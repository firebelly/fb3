class CreateProductsCarts < ActiveRecord::Migration
  def change
    create_table :refinery_products_carts do |t|
      t.string :session_id

      t.timestamps
    end

    add_index :refinery_products_carts, :session_id
  end
end
