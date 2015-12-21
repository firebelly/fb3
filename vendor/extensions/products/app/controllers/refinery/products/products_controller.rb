module Refinery
  module Products
    class ProductsController < ::ApplicationController

      before_action :get_defaults, :get_cart

      def index
        @products = Product.order('position ASC')
        present(@page)
      end

      def show
        @product = Product.friendly.find(params[:id])
        @body_class = 'single'

        # meta tags
        @page_description = @product.description
        @page_image = @product.images.first.thumbnail(geometry: :large).convert('-quality 70').url unless @product.images.blank?

        present(@product)
      end

    protected

      def get_defaults
        @page = ::Refinery::Page.where(:link_url => "/products").first
      end

    end
  end
end
