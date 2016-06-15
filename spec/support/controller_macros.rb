
module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      user = FactoryGirl.create(:admin) 
      session[:user] = user
      sign_in user
      
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      session[:user] = user
      sign_in user
    end
  end


end