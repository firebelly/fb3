class CreateFirebellyHighlights < ActiveRecord::Migration

  def up
    create_table :refinery_firebelly_highlights do |t|
      t.text :highlight
      t.date :date
      t.integer :position

      t.timestamps
    end
    add_index :refinery_firebelly_highlights, :date

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-firebelly"})
    end

    drop_table :refinery_firebelly_highlights

  end

end
