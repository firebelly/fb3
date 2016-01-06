module Refinery
  module NewsPosts
    class NewsPostsController < ::ApplicationController

      before_action :get_news_posts, only: [:index, :feed]
      before_action :get_defaults

      def index
        present(@page)
      end

      def feed
        response.headers['Cache-Control'] = 'public, max-age=3600'
        respond_to do |format|
          format.atom { render :layout => false }
          format.rss { redirect_to refinery.news_posts_feed_path(:format => :atom), :status => :moved_permanently }
        end
      end


      def tagged
        @tag = ActsAsTaggableOn::Tag.friendly.find(params[:tag])
        @news_posts = NewsPost.published
        @page_title = "Posts tagged #{@tag.name}"
        render 'index'
      end

      def show
        @news_post = NewsPost.friendly.find(params[:id])
        if !@news_post.published? and !current_refinery_user.has_role?(:refinery)
          return redirect_to '/thoughts'
        end
        @page_image = @news_post.image.thumbnail(geometry: :large).convert('-quality 70').url unless @news_post.image.blank?
        present(@news_post)
      end

    protected

      def get_news_posts
        @news_posts = NewsPost.published.order('position ASC')
      end

      def get_defaults
        @tags = NewsPost.published.tag_counts_on(:tags)
        @page = ::Refinery::Page.where(:link_url => "/news_posts").first
      end

    end
  end
end
