module Refinery
  module Projects
    class Project < Refinery::Core::BaseModel
      extend FriendlyId
      self.table_name = 'refinery_projects'

      friendly_id :title, :use => [:slugged]
      friendly_id :slug_candidates, use: :slugged

      def slug_candidates
        [
          :title,
          [:title, :subtitle]
        ]
      end

      validates :title, :presence => true

      belongs_to :image, :class_name => '::Refinery::Image'
      belongs_to :industry, :class_name => '::Refinery::Projects::ProjectIndustry'

      acts_as_indexed :fields => [:title, :subtitle, :summary, :content]
      acts_as_taggable_on :services

      scope :published, -> { where(:published => true).order('position ASC') }

      def should_generate_new_friendly_id?
        title_changed?
      end

      def service_classes
        service_counts.map { |t| t.slug }.join(' ')
      end
    end
  end
end
