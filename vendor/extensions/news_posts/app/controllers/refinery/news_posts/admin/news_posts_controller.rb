module Refinery
  module NewsPosts
    module Admin
      class NewsPostsController < ::Refinery::AdminController

        crudify :'refinery/news_posts/news_post'

        private

        # Only allow a trusted parameter "white list" through.
        def news_post_params
          params.require(:news_post).permit(:title, :date, :content, :image_id, :user_id, :position, :image_caption, :sidebar, :published, :tag_list)
        end
      end
    end
  end
end
