require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean


describe CartsController do

	describe "For user" do

		login_user

		before(:each) do
			@user = session[:user]
		end


		describe "Show" do

			it "create new cart if cart don't create before" do
				get :show
				cart = assigns[:cart]
				cart.should_not be_nil
			end

			it "new cart created for current user" do
				get :show
				@cart = assigns[:cart]
				@cart.id.should == @user.cart.id
			end

			it "if cart has been already created new cert not created" do
				get :show
				cart1 = assigns[:cart]
				Cart.where("user_id = ?",  @user.id).count.should == 1
			end

		end

		describe "Add item" do

			login_user

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]							
				@client1 = FactoryGirl.create(:client, user: @user)
				@client2 = FactoryGirl.create(:client)
			    @task_client1  = FactoryGirl.create(:task, client: @client1)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)
			end		

			it "create new cart if cart don't create before" do
				get :add_item
				cart = assigns[:cart]
				cart.should_not be_nil
			end

			it "new cart created for current user" do
				get :add_item
				@cart = assigns[:cart]
				@cart.id.should == @user.cart.id
			end

			it "if cart has been already created new cert not created" do
				get :add_item
				cart1 = assigns[:cart]
				Cart.where("user_id = ?",  @user.id).count.should == 1
			end

			it "respond status 404 if pass not existing task id" do
				get :add_item, task_id: 0
				response.status.should == 404
			end

			it "respond status 404 if not pass task id" do
				get :add_item
				response.status.should == 404
			end

			it "redirect back if valid adding item to cart" do
				get :add_item, task_id: @task_client1.id
				response.should redirect_to "/tasks"
			end

			it "add item to cart only once" do
				get :add_item, task_id: @task_client1.id
				get :add_item, task_id: @task_client1.id
				cart = Cart.where("user_id = ?", @user.id).first
				CartItem.where("cart_id = ? AND task_id = ?", cart.id, @task_client1.id).count.should == 1			
			end

			it "render 404 if try add to cart task that not belong to current user" do
				get :add_item, task_id: @task_client2.id
				response.status.should == 404
			end
		end

		describe "Delete item" do 

			login_user

			before(:each) do
				request.env["HTTP_REFERER"] = "/tasks"

				@user = session[:user]	
				cart = FactoryGirl.create(:cart, user: @user)						
				@client1 = FactoryGirl.create(:client, user: @user)
			    @task_client1  = FactoryGirl.create(:task, client: @client1)
			    @cart_item1 = FactoryGirl.create(:cart_item, task: @task_client1, cart: cart)

			    @client2 = FactoryGirl.create(:client)
			    @task_client2  = FactoryGirl.create(:task, client: @client2)
			    @cart_item2 = FactoryGirl.create(:cart_item, task: @task_client2)
			end	

			it "render 404 if try delete not existing item" do
				delete :delete_item, id: 0
				response.status.should == 404
			end

			it "render 404 if try delete item that not belong's current user" do
				delete :delete_item, id: @cart_item2.id
				response.status.should == 404
			end

			it "redirect back when delete success" do
				delete :delete_item, id: @cart_item1.id
				response.should redirect_to "/tasks"
			end

		end
	end

	describe "For admin" do
	end

	describe "For new user" do

		login_user

		describe "Show" do 

			it "before first call show or item add cart is nil" do
				new_user = FactoryGirl.create(:user)
				new_user.cart.should be_nil
			end

		end
	end

	describe "For not sign user" do

		describe "Show" do
			it "show sign in when try show cart" do
				get :show
				assert_redirected_to :controller => "devise/sessions", 
							 		  action: :new
			end

		end

		describe "Add Item" do
			it "show sign in when try add item to cart" do
				get :add_item 
				assert_redirected_to :controller => "devise/sessions", 
								 		  action: :new
			end
		end

		describe "Delete Item" do
			it "show sign in when try delete item from cart" do
				delete :delete_item
				assert_redirected_to :controller => "devise/sessions", 
								 		  action: :new
			end
		end
	end
end