Refinery::PagesController.class_eval do
  before_action :get_defaults, :check_redirect

private

  def get_defaults
    fresh_when(@page, last_modified: @page.updated_at.utc, public: !current_refinery_user.has_role?(:refinery))
    @current_section = (@page.parent) ? @page.root.title.parameterize : @page.title.parameterize
    @body_class = "single page"
    @body_class << " #{@current_section}"
    @child_pages = @page.children.where(:show_in_menu => true).where(:draft => false)
    @highlights = ::Refinery::Firebelly::Highlight.order('date DESC')
    @page_description = @page.content_for(:body)
    if @page.images.any?
      @page_image = @page.images.first.thumbnail(geometry: :large).convert('-quality 70').url
    end
  end

  def check_redirect
    if @page.parent
      if @page.parent.friendly_id =~ /(people|endeavors)/
        redirect_to "/#{@page.parent.slug}##{@page.friendly_id}" and return
      end
    end
  end
end
