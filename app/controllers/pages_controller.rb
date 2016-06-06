class PagesController < ApplicationController
	def index		
	end

	def show		
	end

	def sign_in
		render "/registration/sessions/new"
	end
end
