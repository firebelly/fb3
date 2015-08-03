module Refinery
  module NewsPosts
    class NewsPost < Refinery::Core::BaseModel
      extend FriendlyId
      self.table_name = 'refinery_news_posts'

      friendly_id :title, :use => [:slugged]
      acts_as_indexed :fields => [:title, :content]

      validates :title, :presence => true, :uniqueness => true
      validates :content, :presence => true

      acts_as_taggable_on :tags

      belongs_to :image, :class_name => '::Refinery::Image'
      belongs_to :user, :class_name => '::Refinery::User'

      def should_generate_new_friendly_id?
        title_changed?
      end

      scope :published, -> { where(:published => true) }

    end
  end
end
