require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe ClientsController do
	before(:each) do
		client1 = FactoryGirl.create(:client)
		client2 = FactoryGirl.create(:client)
	    @task_list_client1 	= FactoryGirl.create_list(:task, 3, client: client1)
	    @task_list_client2  = FactoryGirl.create_list(:task, 2, client: client2)
  	end

	describe 'Index' do

		it "should show all for admin" do
			@simple_user_task_list.count.should == 3
		end

		it "should show task only for current user" do
			@simple_user_task_list.count.should == 3
		end

	end	

end
