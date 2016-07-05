class AddVideoToProjects < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :video_url, :string
  end
end
