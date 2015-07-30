module Refinery
  module Products
    class ProductsController < ::ApplicationController

      before_action :get_defaults

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
        @cart = Cart.find_or_create_by(session_id: session.id)
      end


    end
  end
end
