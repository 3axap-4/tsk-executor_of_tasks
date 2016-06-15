require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean


describe ClientsController do

	describe 'For admin' do

		login_admin	
			

		before(:each) do

			user = session[:user]
			client1 = FactoryGirl.create_list(:client, 3)
			client2 = FactoryGirl.create(:client)
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
		end		
	end	

	describe "For user" do

		login_user

		before(:each) do
			user = session[:user]
			@client1 = FactoryGirl.create_list(:client, 3, user: user)
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
				post :create, client: {name: "name_test", fio: "fio_test", user: @user}
				expect(subject).to redirect_to :action => :show,
                                     :id => assigns(:client).id
			end

			it "render new if validation fail" do
				post :create, client: {name: "name_test", user: @user}
				response.should render_template('new')
			end
		end

		describe "Edit" do
			
		end

		describe "Delete" do
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

		it "edit should redirect to sign in page" do
			get :edit, id: @client2.id
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
