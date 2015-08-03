class CreateImageTranslationTable < ActiveRecord::Migration
  def change
    create_table :refinery_image_translations do |t|
    	t.integer  :refinery_image_id
    	t.string   :locale
    	t.text     :caption

    	t.timestamps
    end
    add_index :refinery_image_translations, :refinery_image_id

  end
end
