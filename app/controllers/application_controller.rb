class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :configure_permitted_perameters, if: :devise_controller?

	def after_sign_in_path_for(resource)
  		pages_control_panel_url
	end

	protected 

	def check_sign_in
		redirect_to :new_user_session if !user_signed_in?
	end

	def check_sign_in_admin
		redirect_to :new_user_session if !user_signed_in? || !current_user.is_admin?
	end

	def configure_permitted_perameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:fio])
		 devise_parameter_sanitizer.permit(:account_update, keys: [:is_admin, :fio])
	end

	def render_404
	  respond_to do |format|
	    format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => 404 }
	    format.xml  { head :not_found }
	    format.any  { head :not_found }
	  end
	end
end