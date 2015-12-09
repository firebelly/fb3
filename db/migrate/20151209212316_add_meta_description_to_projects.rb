class AddMetaDescriptionToProjects < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :meta_description, :text
  end
end
