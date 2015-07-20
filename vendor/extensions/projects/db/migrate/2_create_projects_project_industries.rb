class CreateProjectsProjectIndustries < ActiveRecord::Migration

  def up
    create_table :refinery_projects_project_industries do |t|
      t.string :name
      t.string :slug
      t.integer :position

      t.timestamps
    end
    add_index :refinery_projects_project_industries, :slug, unique: true

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-projects"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/projects/project_industries"})
    end

    drop_table :refinery_projects_project_industries

  end

end
