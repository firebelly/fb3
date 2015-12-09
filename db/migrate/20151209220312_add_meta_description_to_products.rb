class AddMetaDescriptionToProducts < ActiveRecord::Migration
  def change
    add_column :refinery_products, :meta_description, :text
  end
end
