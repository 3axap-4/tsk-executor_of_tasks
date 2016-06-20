require 'spec_helper'

describe UsersController do

  describe "For admin" do
	login_admin

    it "Shold success" do
      get 'index'
      response.should be_success

    end

 describe "For user" do
	login_user

    it "Shold fail" do
      get 'index'
      response.should_not be_success
      
    end

  end


  end

end
