require 'spec_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

describe ClientsController do

	describe 'Index' do

		it "should do something" do
			user = FactoryGirl.create(:user)
			user.email.should == "1"
		end
	end	
end
