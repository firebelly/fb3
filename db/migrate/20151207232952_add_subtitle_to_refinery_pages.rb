class AddSubtitleToRefineryPages < ActiveRecord::Migration
  def change
    add_column :refinery_pages, :subtitle, :string
  end
end
