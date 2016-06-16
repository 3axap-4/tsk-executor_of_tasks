require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe CommentsController do


	describe "For user" do
	end	

	describe "For admin" do
	end	

	describe "For not sign in user" do

		describe "Create" do

			before(:each) do

				client1 = FactoryGirl.create(:client)
			    @task1 = FactoryGirl.create(:task)
			end

			it "create should redirect sign in" do
				post :create,  body: "some comment body"
				assert_redirected_to :controller => "devise/sessions", 
							 		  action: :new
			end

		end

	end	

end