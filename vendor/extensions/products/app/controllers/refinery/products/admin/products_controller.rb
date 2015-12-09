module Refinery
  module Products
    module Admin
      class ProductsController < ::Refinery::AdminController

        crudify :'refinery/products/product'

        private

        # Only allow a trusted parameter "white list" through.
        def product_params
          params.require(:product).permit(:title, :price, :weight, :description, :details, :position, :published, :meta_description, images_attributes: [:id, :caption])
        end
      end
    end
  end
end
