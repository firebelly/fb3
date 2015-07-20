module Refinery
  module Projects
    module Admin
      class ProjectsController < ::Refinery::AdminController

        crudify :'refinery/projects/project'

        private

        # Only allow a trusted parameter "white list" through.
        def project_params
          params.require(:project).permit(:title, :subtitle, :summary, :content, :image_id, :industry_id, :position, :published, :service_list)
        end
      end
    end
  end
end
