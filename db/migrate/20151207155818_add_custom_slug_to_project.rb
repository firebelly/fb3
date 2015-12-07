class AddCustomSlugToProject < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :custom_slug, :string
  end
end
