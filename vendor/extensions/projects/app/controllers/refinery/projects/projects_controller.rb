module Refinery
  module Projects
    class ProjectsController < ::ApplicationController
      include ActionView::Helpers::TextHelper

      before_action :find_all_projects
      before_action :find_page

      def index
        @body_class = 'index'
        @industries = ProjectIndustry.all
        @services = Project.service_counts
        @projects = Project.published
        @current_section = 'work'
        present(@page)
      end

      def show
        @project = Project.friendly.find(params[:id])
        @body_class = 'single'
        present(@page)
      end

      # quickly upload batch of images and append to project.content field
      def upload_images
        @project = Project.find(params[:project_id])
        image_html = ''
        if !(params[:images_number].blank? && params[:images_title].blank? && params[:images_desc].blank?)
          image_html += '<div class="project-summary user-content">'
          image_html += "<h3 class=\"h1 number-header\">#{params[:images_number]}</h3>" unless params[:images_number].blank?
          image_html += "<h2>#{params[:images_title]}</h2>" unless params[:images_title].blank?
          image_html += "#{simple_format params[:images_desc]}" unless params[:images_desc].blank?
          image_html += '</div>'
        end
        unless params[:images].blank? 
          params[:images].each do |image|
            if saved_image = ::Refinery::Image.create(image: image[1])
              image_html += "\n<p><img src=\"#{saved_image.thumbnail(geometry: :portfolio).convert('-quality 75').url}\" data-id=\"#{saved_image.id}\"</p>";
            end
          end
        end
        @project.content += image_html
        @project.save
        respond_to do |format|
          format.json { head :ok }
          format.html { redirect_to refinery.projects_project_path @project }
        end
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
