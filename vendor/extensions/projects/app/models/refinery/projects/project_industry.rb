module Refinery
  module Projects
    class ProjectIndustry < Refinery::Core::BaseModel
    	extend FriendlyId

    	friendly_id :name, :use => [:slugged]

    	validates :name, :presence => true, :uniqueness => true

    	has_many :projects, :foreign_key => 'industry_id'

    end
  end
end
