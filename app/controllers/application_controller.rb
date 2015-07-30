class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

	before_filter :set_body_id

  def redirect_to_work
	  redirect_to '/work'
	end

	protected

	def set_body_id
	  body_id = request.path.gsub(/\/?(en\/|es\/)?([^\/]+)(.*)/,'\\2')
	  body_id = body_id.gsub(/\-page/, '')
	  @body_id = "#{body_id}-page"
	end

end
