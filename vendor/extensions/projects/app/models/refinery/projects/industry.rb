module Refinery
  module Projects
    class Industry < Refinery::Core::BaseModel
      extend FriendlyId
      self.table_name = 'refinery_industries'

      friendly_id :title, :use => [:slugged]

      validates :title, :presence => true, :uniqueness => true

      has_many :projects, :class_name => '::Refinery::Projects::Project'

    end
  end
end
