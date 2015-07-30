Refinery::PagesController.class_eval do
  before_filter :get_defaults

  def get_defaults
    @current_section = (@page.parent) ? @page.root.title.parameterize : @page.title.parameterize
    @body_class = "single"
    @body_class << " #{@current_section}"
    @child_pages = @page.children.where(:show_in_menu => true)
  end
end
