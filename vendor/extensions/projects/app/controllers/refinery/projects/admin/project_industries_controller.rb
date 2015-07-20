module Refinery
  module Projects
    module Admin
      class ProjectIndustriesController < ::Refinery::AdminController

        crudify :'refinery/projects/project_industry',
                :title_attribute => 'name'

        private

        # Only allow a trusted parameter "white list" through.
        def project_industry_params
          params.require(:project_industry).permit(:name)
        end
      end
    end
  end
end
