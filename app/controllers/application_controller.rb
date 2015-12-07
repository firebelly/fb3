class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_body_id, :get_projects

  def redirect_to_work
    redirect_to '/work'
  end

private

  def get_projects
    @projects = ::Refinery::Projects::Project.published
  end

  def set_body_id
    body_id = request.path.gsub(/\/?(en\/|es\/)?([^\/]+)(.*)/,'\\2')
    body_id = body_id.gsub(/\-page/, '')
    @body_id = "#{body_id}-page"
  end

  def get_cart
    session.delete 'init'
    @cart = ::Refinery::Products::Cart.find_or_create_by(session_id: session.id)
  end

end
