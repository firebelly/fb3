class AddAltImageIdToProject < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :alt_image_id, :integer
	  add_index :refinery_projects, :alt_image_id
  end
end
