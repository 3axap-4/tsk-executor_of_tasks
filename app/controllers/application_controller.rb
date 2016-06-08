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

	def configure_permitted_perameters
		 devise_parameter_sanitizer.permit(:account_update, keys: [:is_admin])
	end

end