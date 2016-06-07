class PagesController < ApplicationController

	before_filter :check_sign_in, only: [:control_panel]

	def index		
	end

	def control_panel		
	end
end
