class AddMetaDescriptionToNewsPosts < ActiveRecord::Migration
  def change
    add_column :refinery_news_posts, :meta_description, :text
  end
end
