class CreateRefineryIndustries < ActiveRecord::Migration
  def change
    create_table :refinery_industries do |t|
      t.string :title
      t.string :slug
      t.integer :position
    end
    add_index :refinery_industries, :slug, unique: true
  end
end
