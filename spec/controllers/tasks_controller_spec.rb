require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean


describe TasksController do

	let(:new_valid_attribute){
		{ title: "new title", description: "new description 123", price: 2}
	}
	
	let(:new_invalid_attribute){
		{ title: nil, description: "new desc 123" }
	}

		def update_valid_task(task)
		put :update, { id: task.to_param, task: new_valid_attribute } 
		expect(subject).to redirect_to :action => :show,
                         			   :id => assigns(:task).id
	end





	describe "For user" do

		login_user
	
		describe "Index" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)			    
			end		

			it "should select tasks belong current user" do
				@task_client1  = FactoryGirl.create_list(:task, 3, client: @client1)
			    @task_client2  = FactoryGirl.create_list(:task, 4, client: @client2)
				get :index
				assigns(:tasks).count.should == 3
			end

			it "if task not created @task.count must be 0" do
				get :index
				assigns(:tasks).count.should == 0
			end
		end

		describe "Show" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end		


			it "should render show template if task found" do
				get :show, id: @task_client1.id
				response.should render_template("show")
			end

			it "should return status 404 if task not found" do
				get :show, id: 0
				response.status.should == 404
			end 

			it "should return status 404 if try show task that not belong to current user" do
				get :show, id: @task_client2.id
				response.status.should == 404
			end
		end

		describe "Create" do

			it "should redirect to show if create was correct" do
				user = session[:user]							
				client1 = FactoryGirl.create(:client, user: @user)
				post :create, task: { title: "title", description: "desc", price: 3, client_id: client1.id}
				expect(subject).to redirect_to :action => :show,
                                 			   :id => assigns(:task).id
			end			
		end

		describe "Edit" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end		

			it "should render edit template if task is found" do
				get :edit, id: @task_client1.id
				response.should render_template("edit")
			end

			it "should render 404 if task not found" do
				get :edit, id: 0
				response.status.should == 404
			end

			it "should render 404 if task don't belong to current user" do
				get :edit, id: @task_client2.id
				response.status.should == 404
			end
		end

		describe "Update" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end		


			it "redirect to show if update is valid" do
				update_valid_task @task_client1
			end

			it "redirect to edit if validation fail" do 
				put :update, { id: @task_client1.to_param, task: new_invalid_attribute } 
				response.should render_template('edit')
			end

			it "render 404 if try to edit client that not belong current user" do
				put :update, { id: @task_client2.to_param, task: new_valid_attribute } 
				response.status.should == 404
			end
		end

		describe "Destroy" do
			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end	

			it "redirect to index if destroy successful" do
				delete :destroy, id: @task_client1.id
				assert_redirected_to action: :index
			end

			it "sould response status 404 if task doesn't found" do
				delete :destroy, id: 0
				response.status.should == 404
			end

			it "sould response status 404 if task doesn't belong to current user" do
				delete :destroy, id: @task_client2.id
				response.status.should == 404
			end
		end
	end

	describe "For admin" do

		login_admin

		describe "Index" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)
			    
			end		

			it "should select all tasks" do
				@task_client1  = FactoryGirl.create_list(:task, 3, client: @client1)
			    @task_client2  = FactoryGirl.create_list(:task, 4, client: @client2)
				get :index
				assigns(:tasks).count.should == 7
			end
		end

		describe "Show" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end		


			it "should render show template if task found" do
				get :show, id: @task_client1.id
				response.should render_template("show")
			end

			it "should render show template for task that belong any other users" do
				get :show, id: @task_client2.id
				response.should render_template("show")
			end
		end

		describe "Edit" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end		

			it "should render edit template if task is found" do
				get :edit, id: @task_client1.id
				response.should render_template("edit")
			end

			it "should render edit for all task" do
				get :edit, id: @task_client2.id
				response.should render_template("edit")
			end
		end

		describe "Update" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end		


			it "redirect to show if update is valid" do
				update_valid_task @task_client1
			end

			it "redirect to edit if validation fail" do 
				put :update, { id: @task_client1.to_param, task: new_invalid_attribute } 
				response.should render_template('edit')
			end

			it "redirect to show can update any task" do
				update_valid_task @task_client2
			end
		end

		describe "Destroy" do

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)	
				@task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)		    
			end	

			it "redirect to index if destroy successful" do
				delete :destroy, id: @task_client1.id
				assert_redirected_to action: :index
			end

			it "redirect to index if destroy successful task doesn't belong current user" do
				delete :destroy, id: @task_client2.id
				assert_redirected_to action: :index
			end
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