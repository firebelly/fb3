module Refinery
  module Projects
    class ProjectIndustriesController < ::ApplicationController

      before_action :find_all_project_industries
      before_action :find_page

      def index
        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project_industry in the line below:
        present(@page)
      end

      def show
        @project_industry = ProjectIndustry.find(params[:id])

        # you can use meta fields from your model instead (e.g. browser_title)
        # by swapping @page for @project_industry in the line below:
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
