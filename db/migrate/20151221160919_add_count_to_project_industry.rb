class AddCountToProjectIndustry < ActiveRecord::Migration
  def change
    add_column :refinery_projects_project_industries, :count, :integer
  end
end
