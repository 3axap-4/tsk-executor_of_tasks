class UsersController < ApplicationController
  
	before_action :check_sign_in_admin, only: [:index]


  def index
  	@users = User.all
  end
end
