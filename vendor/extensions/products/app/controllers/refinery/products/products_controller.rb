module Refinery
  module Products
    class ProductsController < ::ApplicationController

      before_action :get_defaults
      before_action :get_cart

      def index
        @products = Product.order('position ASC')
        present(@page)
      end

      def show
        @product = Product.friendly.find(params[:id])
        present(@page)
      end

    protected

      def get_defaults
        @page = ::Refinery::Page.where(:link_url => "/products").first
      end

    end
  end
end
