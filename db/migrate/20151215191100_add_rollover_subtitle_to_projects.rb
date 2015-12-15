class AddRolloverSubtitleToProjects < ActiveRecord::Migration
  def change
    add_column :refinery_projects, :rollover_subtitle, :string
  end
end
