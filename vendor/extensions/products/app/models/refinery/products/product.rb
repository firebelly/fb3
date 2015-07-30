module Refinery
  module Products
    class Product < Refinery::Core::BaseModel
      self.table_name = 'refinery_products'

      validates :title, :presence => true, :uniqueness => true

      acts_as_indexed :fields => [:title, :description, :details]

      has_many_page_images

    end
  end
end
