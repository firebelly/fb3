# This migration comes from refinery_projects (originally 1)
class CreateProjectsProjects < ActiveRecord::Migration

  def up
    create_table :refinery_projects do |t|
      t.string :title
      t.string :slug
      t.string :subtitle
      t.text :summary
      t.text :content
      t.integer :image_id
      t.integer :industry_id
      t.integer :position
      t.boolean :published
      t.integer :position

      t.timestamps
    end
    add_index :refinery_projects, :slug, unique: true

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-projects"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/projects/projects"})
    end

    drop_table :refinery_projects

  end

end
