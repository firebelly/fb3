class CreateProductsPaypalRecords < ActiveRecord::Migration
  def change
    create_table :refinery_products_paypal_records do |t|
      t.text :params

      t.timestamps
    end
  end
end
