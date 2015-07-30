module Refinery
  module Products
    class Product < Refinery::Core::BaseModel
    	extend FriendlyId
      self.table_name = 'refinery_products'

    	friendly_id :title, :use => [:slugged]

      validates :title, :presence => true
      validates :product_category_id, :presence => true
      validates :description, :presence => true
      validates :price, :presence => true

      acts_as_indexed :fields => [:title, :description, :details]

      has_many_page_images

    end
  end
end
