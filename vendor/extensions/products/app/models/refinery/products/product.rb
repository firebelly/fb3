module Refinery
  module Products
    class Product < Refinery::Core::BaseModel
      before_create :bump_positions

    	extend FriendlyId
      self.table_name = 'refinery_products'

    	friendly_id :title, :use => [:slugged]

      validates :title, :presence => true
      validates :price, :presence => true

      acts_as_indexed :fields => [:title, :description, :details]

      def should_generate_new_friendly_id?
        title_changed?
      end

      has_many_page_images

    private

      def bump_positions
        self.position = 0
        Product.update_all('position = position + 1')
      end
    end
  end
end
