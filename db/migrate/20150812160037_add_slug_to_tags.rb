class AddSlugToTags < ActiveRecord::Migration
  def change
    add_column :tags, :slug, :string
    ActsAsTaggableOn::Tag.find_each(&:save)
  end
end
