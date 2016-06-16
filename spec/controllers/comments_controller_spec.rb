require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe CommentsController do

	describe "For user" do

		login_user

		describe "Create" do

			before(:each) do
				@user = session[:user]
				@client1 = FactoryGirl.create(:client, user: @user)
			    @task1 = FactoryGirl.create(:task, client: @client1)

				@client2 = FactoryGirl.create(:client)
			    @task2 = FactoryGirl.create(:task, client: @client2)
			end

			it "should respond status 200 after ajax request" do
				xhr :post, :create, comment: { body: "some comment body", task: @task1, client: @client1 }
				redirect_to :back
			end

			it "should render 404 if try add comment for not existing task" do
				post :create, comment: { body: "some comment body", task_id: 0, client: @client1 }
				response.status.should == 404
			end

			it "should render 404 if try add comment when task_id not pass or nil" do
				xhr :post, :create, comment: { body: "some comment body", client: @client1 }
				response.status.should == 404
			end

			it "should render 404 if try add comment to task which client don't belong current user" do
				xhr :post, :create, comment: { body: "some comment body", task: @task2, client: @client2 }
				response.status.should == 404
			end
		end
	end	

	describe "For admin" do

		login_admin
		before(:each) do
			@admin = session[:user]
			@client1 = FactoryGirl.create(:client, user: @admin)
		    @task1 = FactoryGirl.create(:task, client: @client1)

			@client2 = FactoryGirl.create(:client)
		    @task2 = FactoryGirl.create(:task, client: @client2)
		end

		describe "Create" do

			it "should respond status 200 after ajax request" do
				xhr :post, :create, comment: { body: "some comment body", task: @task1, client: @client1 }
				redirect_to :back
			end

			it "should render 404 if try add comment for not existing task" do
				post :create, comment: { body: "some comment body", task_id: 0, client: @client1 }
				response.status.should == 404
			end

			it "should render 404 if try add comment when task_id not pass or nil" do
				xhr :post, :create, comment: { body: "some comment body", client: @client1 }
				response.status.should == 404
			end

			it "should respond status 200 after ajax request that add comment to any task" do
				xhr :post, :create, comment: { body: "some comment body", task: @task2, client: @client2 }
				redirect_to :back
			end
		end
	end	

	describe "For not sign in user" do

		describe "Create" do

			before(:each) do
				@client1 = FactoryGirl.create(:client)
			    @task1 = FactoryGirl.create(:task, client: @client1)
			end

			it "create should redirect sign in" do				
				post :create,  comment: { body: "some comment body", task: @task1, client: @client1 }
				assert_redirected_to :controller => "devise/sessions", 
							 		  action: :new
			end

		end
	end	

end