module Refinery
  module NewsPosts
    class NewsPostsController < ::ApplicationController

      before_action :get_news_posts
      before_action :get_defaults
      before_action :find_page

      def index
        present(@page)
      end

      def feed
        response.headers['Cache-Control'] = 'public, max-age=3600'
        
        @page_title = "News - Firebelly Design"
        @updated = @news_posts.first.date unless @news_posts.empty?
        
        respond_to do |format|
          format.atom { render :layout => false }
          format.rss { redirect_to feed_path(:format => :atom), :status => :moved_permanently }
        end
      end


      def show
        @news_post = NewsPost.friendly.find(params[:id])
        if !@news_post.published?
          return redirect_to '/news'
        end
        present(@page)
      end

    protected

      def get_defaults
        @tags = NewsPost.published.tag_counts_on(:tags)
        @news_posts = NewsPost.published.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/news_posts").first
      end

    end
  end
end
