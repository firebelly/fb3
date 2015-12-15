module Refinery
  module Projects
    module Admin
      class ProjectsController < ::Refinery::AdminController

        crudify :'refinery/projects/project', 
                :paging => false, 
                :order  => 'position ASC'

        private

        # Only allow a trusted parameter "white list" through.
        def project_params
          params.require(:project).permit(:title, :subtitle, :summary, :content, :image_id, :industry_id, :position, :published, :service_list, :alt_image_id, :custom_slug, :meta_description, :rollover_subtitle)
        end
      end
    end
  end
end
