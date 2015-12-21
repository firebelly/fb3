class AddBrowserTitleToProjects < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :browser_title, :string
  end
end
