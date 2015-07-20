# This migration comes from refinery_news_posts (originally 1)
class CreateNewsPostsNewsPosts < ActiveRecord::Migration

  def up
    create_table :refinery_news_posts do |t|
      t.string :title
      t.datetime :date
      t.text :content
      t.integer :image_id
      t.integer :user_id
      t.integer :position
      t.text :image_caption
      t.text :sidebar
      t.boolean :published
      t.integer :position

      t.timestamps
    end

  end

  def down
    if defined?(::Refinery::UserPlugin)
      ::Refinery::UserPlugin.destroy_all({:name => "refinerycms-news_posts"})
    end

    if defined?(::Refinery::Page)
      ::Refinery::Page.delete_all({:link_url => "/news_posts/news_posts"})
    end

    drop_table :refinery_news_posts

  end

end
