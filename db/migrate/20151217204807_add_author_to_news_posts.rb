class AddAuthorToNewsPosts < ActiveRecord::Migration
  def change
    add_column :refinery_news_posts, :author, :string
  end
end
