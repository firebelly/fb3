module Refinery
  module NewsPosts
    class NewsPostsController < ::ApplicationController

      before_action :find_all_news_posts
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @news_post in the line below:
        present(@page)
      end

      def show
        @news_post = NewsPost.friendly.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @news_post in the line below:
        present(@page)
      end

    protected

      def find_all_news_posts
        @news_posts = NewsPost.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/news_posts").first
      end

    end
  end
end
