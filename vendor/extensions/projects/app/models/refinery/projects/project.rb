module Refinery
  module Projects
    class Project < Refinery::Core::BaseModel
      extend FriendlyId
      self.table_name = 'refinery_projects'

      friendly_id :title, :use => [:slugged]

      validates :title, :presence => true, :uniqueness => true

      belongs_to :image, :class_name => '::Refinery::Image'
      belongs_to :industry, :class_name => '::Refinery::Projects::Industry'

      acts_as_indexed :fields => [:title, :subtitle, :summary, :content]
      acts_as_taggable_on :services

      scope :published, -> { where(:published => true).order('position ASC') }

    end
  end
end
