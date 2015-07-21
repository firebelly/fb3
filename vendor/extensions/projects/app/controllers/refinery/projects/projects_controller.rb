module Refinery
  module Projects
    class ProjectsController < ::ApplicationController

      before_action :find_all_projects
      before_action :find_page

      def index
        @body_class = 'index'
        @industries = ProjectIndustry.all
        @projects = Project.published
        @current_section = 'work'
        present(@page)
      end

      def show
        @project = Project.friendly.find(params[:id])
        @body_class = 'single'
        present(@page)
      end

    protected

      def find_all_projects
        @projects = Project.order('position ASC')
      end

      def find_page
        @page = Refinery::Page.where(:link_url => "/projects").first
      end

    end
  end
end
