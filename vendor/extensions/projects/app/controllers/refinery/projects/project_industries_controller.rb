module Refinery
  module Projects
    class ProjectIndustriesController < ::ApplicationController

      before_action :find_all_project_industries
      before_action :find_page

      def index
        present(@page)
      end

      def show
        @project_industry = ProjectIndustry.find(params[:id])
        present(@page)
      end

    protected

      def find_all_project_industries
        @project_industries = ProjectIndustry.order('position ASC')
      end

      def find_page
        @page = ::Refinery::Page.where(:link_url => "/project_industries").first
      end

    end
  end
end
