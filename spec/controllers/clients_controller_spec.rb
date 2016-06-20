require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean


describe ClientsController do

	let(:new_valid_attribute){
		{ name: "new name", fio: "new fio", description: "new desc" }
	}
	
	let(:new_invalid_attribute){
		{ name: nil, fio: "new fio", description: "new desc" }
	}

	def create_valid_client(user)
		post :create, client: {name: "name_test", fio: "fio_test", user: user}
		expect(subject).to redirect_to :action => :show,
                                     	:id => assigns(:client).id
	end

	def edit_valid_client(id)
		get :edit, id: id
		response.should render_template('edit')
	end

	def update_valid_client(user)
		put :update, { id: user.to_param, client: new_valid_attribute } 
		expect(subject).to redirect_to :action => :show,
                         			   :id => assigns(:client).id
	end

	def correct_destroy(id)
		delete :destroy, id: id
		assert_redirected_to action: :index
	end


	describe 'For admin' do

		login_admin	
			
		before(:each) do

			@admin = session[:user]
			@client1 = FactoryGirl.create_list(:client, 3, user: @admin)
			@client2 = FactoryGirl.create(:client)
		    #@task_list_client1 	= FactoryGirl.create_list(:task, 3, client: client1)
		    #@task_list_client2  = FactoryGirl.create_list(:task, 2, client: client2)
		end

		describe "Index" do

			it "should show all for admin" do		
				get 'index'
				assigns(:clients).count.should == 4
			end
		end

		describe "Show" do

			it "should render Show template if client found" do
				get 'show', id: @client1[0].id
				response.should render_template('show')
			end

			it "should return 404 status if client not found" do
				get :show, id: "0"
				response.status.should == 404
			end

			it "should return 404 status if client don't belong current user" do
				get :show, id: @client2.id
				response.should render_template('show')
			end
		end	

		describe "Create" do

			it "render show if validation pass" do
				create_valid_client @admin
			end

			it "render new if validation fail" do
				post :create, client: {name: "name_test", user: @admin}
				response.should render_template('new')
			end
		end

		describe "Edit" do

			it "should render edit if client found" do
				edit_valid_client @client1[0].id
			end

			it "should render 404 if client found" do
				get :edit, id: 0
				response.status.should == 404
			end

			it "should render 404 if client don't belong to current user" do
				edit_valid_client @client2.id
			end
		end

		describe "Update" do
		
			it "redirect to show if update is valid" do
				update_valid_client @client1[0]
			end

			it "redirect to edit if validation fail" do 
				put :update, { id: @client1[0].to_param, client: new_invalid_attribute } 
				response.should render_template('edit')
			end

			it "render 404 if try to edit client that not belong current user" do
				update_valid_client @client2
			end
		end

		describe "Destroy" do

			it "redirect to client list when destroy" do
				correct_destroy @client1[0].id
			end

			it "status 404 when try to destroy not existing client" do
				delete :destroy, id: 0
				response.status.should == 404
			end

			it "status 404 when try to destroy client that not belong to current user" do
				correct_destroy @client2.id
			end
		end
	end	

	describe "For user" do

		login_user

		before(:each) do
			@user = session[:user]
			@client1 = FactoryGirl.create_list(:client, 3, user: @user)
			@client2 = FactoryGirl.create(:client)
		    #@task_list_client1 	= FactoryGirl.create_list(:task, 3, client: client1)
		    #@task_list_client2  = FactoryGirl.create_list(:task, 2, client: client2)
		end

		describe "Index" do

			it "should show only current user client" do
				get 'index'
				assigns(:clients).count.should == 3
			end
		end

		describe "Show" do

			it "should render Show template if client found" do
				get 'show', id: @client1[0].id
				response.should render_template('show')
			end

			it "should return 404 status if client not found" do
				get :show, id: "0"
				response.status.should == 404
			end

			it "should return 404 status if client don't belong current user" do
				get :show, id: @client2.id
				response.status.should == 404
			end
		end

		describe "Create" do

			it "render show if validation pass" do
				create_valid_client @user
			end

			it "render new if validation fail" do
				post :create, client: {name: "name_test", user: @user}
				response.should render_template('new')
			end
		end

		describe "Edit" do

			it "should render edit if client found" do
				edit_valid_client @client1[0].id
			end

			it "should render 404 if client found" do
				get :edit, id: 0
				response.status.should == 404
			end

			it "should render 404 if client don't belong to current user" do
				get :edit, id: @client2.id
				response.status.should == 404
			end
		end

		describe "Update" do
			
			it "redirect to show if update is valid" do
				update_valid_client @client1[0]
			end

			it "redirect to edit if validation fail" do 
				put :update, { id: @client1[0].to_param, client: new_invalid_attribute } 
				response.should render_template('edit')
			end

			it "render 404 if try to edit client that not belong current user" do
				put :update, { id: @client2.to_param, client: new_valid_attribute } 
				response.status.should == 404
			end
		end

		describe "Destroy" do

			it "redirect to client list when destroy" do
				correct_destroy @client1[0].id
			end

			it "status 404 when try to destroy not existing client" do
				delete :destroy, id: 0
				response.status.should == 404
			end

			it "status 404 when try to destroy client that not belong to current user" do
				delete :destroy, id: @client2.id
				response.status.should == 404
			end
		end
	end

	describe "For new user" do

		login_user

		before(:each) do
			client1 = FactoryGirl.create_list(:client, 3)
			client2 = FactoryGirl.create(:client)
		    #@task_list_client1 	= FactoryGirl.create_list(:task, 3, client: client1)
		    #@task_list_client2  = FactoryGirl.create_list(:task, 2, client: client2)
		end

		describe "Index" do

			it "clients collection should be empty for new user" do
				get 'index'
				assigns(:clients).count.should == 0
			end
		end
	end

	describe "Not sign in user" do

		before(:each) do
			client1 = FactoryGirl.create_list(:client, 3)
			@client2 = FactoryGirl.create(:client)
		end

		it "index should redirect to sign in page" do
			get :index
			assert_redirected_to :controller => "devise/sessions", 
								 action: :new
		end

		it "show should redirect to sign in page" do
			get :show, id: @client2.id
			assert_redirected_to :controller => "devise/sessions", 
								 action: :new
		end

		it "new should redirect to sign in page" do
			get :new
			assert_redirected_to :controller => "devise/sessions", 
								 action: :new
		end

		it "edit should redirect to sign in page" do
			get :edit, id: @client2.id
			assert_redirected_to :controller => "devise/sessions", 
								 action: :new
		end

		it "update should redirect to sign in page" do
			put :update, { id: @client2.to_param, client: @client2.to_param } 
			assert_redirected_to :controller => "devise/sessions", 
									action: :new
		end

		it "delete should redirect to sign in page" do
			get :destroy, id: @client2.id
			assert_redirected_to :controller => "devise/sessions", 
								 action: :new
		end
	end

end