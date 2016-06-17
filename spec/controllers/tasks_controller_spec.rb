require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean


describe TasksController do

	describe "For user" do
	
		describe "Index" do
		end

		describe "Show" do
		end

		describe "Edit" do
		end

		describe "Update" do
		end

		describe "Destroy" do
		end
	end

	describe "For admin" do

		describe "Index" do
		end

		describe "Show" do
		end

		describe "Edit" do
		end

		describe "Update" do
		end

		describe "Destroy" do
		end

	end

	describe "For not sign in user" do

		describe "Index" do

			it "Should redirect to sign in" do
				get :index
				assert_redirected_to :controller => "devise/sessions", 
							 		  action: :new
			end

		end

		describe "Show" do

			it "Should redirect to sign in" do
				get :show, id: 0
				assert_redirected_to :controller => "devise/sessions", 
									  action: :new
			end

		end

		describe "Edit" do

			it "Should redirect to sign in" do
				get :edit, id: 0
				assert_redirected_to :controller => "devise/sessions", 
									  action: :new
			end

		end

		describe "Update" do

			it "Should redirect to sign in" do
				put :update, id: 0
				assert_redirected_to :controller => "devise/sessions", 
									  action: :new
			end

		end

		describe "Destroy" do

			it "Should redirect to sign in" do
				delete :destroy, id: 0
				assert_redirected_to :controller => "devise/sessions", 
									  action: :new
			end

		end


	end

end