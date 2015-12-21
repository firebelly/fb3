module Refinery
  module Projects
    class Project < Refinery::Core::BaseModel
      before_create :bump_positions
      after_save :update_category_counts

      extend FriendlyId
      self.table_name = 'refinery_projects'

      friendly_id :slug_candidates, use: :slugged

      def slug_candidates
        [
          :custom_slug,
          :title,
          [:title, :subtitle]
        ]
      end

      validates :title, :presence => true

      belongs_to :image, :class_name => '::Refinery::Image'
      belongs_to :alt_image, :class_name => '::Refinery::Image'
      belongs_to :industry, :class_name => '::Refinery::Projects::ProjectIndustry'

      acts_as_indexed :fields => [:title, :subtitle, :summary, :content]
      acts_as_taggable_on :services

      scope :published, -> { where(:published => true).order('position ASC') }

      def should_generate_new_friendly_id?
        title_changed? || custom_slug_changed?
      end

      def service_classes
        service_counts.map { |t| t.slug }.join(' ')
      end

      def thumbnail_image
        !alt_image.nil? ? alt_image : image
      end

      def next
        self.class.published.where(["position > ?", self.position]).first
      end

      def prev
        self.class.published.where(["position < ?", self.position]).last
      end

    private

      def bump_positions
        self.position = 0
        Project.update_all('position = position + 1')
      end

      def update_category_counts
        Refinery::Projects::ProjectIndustry.all.each do |category|
          category.update(count: category.projects.published.count)
        end
      end

    end
  end
end
