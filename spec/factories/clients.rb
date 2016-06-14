FactoryGirl.define do

	factory :client do
	 	name "Name"
	    fio "FIO"
	    user { FactoryGirl.create :user }
	end

	factory :client_admin, class: Client do
	 	name "Name"
	    fio "FIO"
	    user { FactoryGirl.create :admin }
	end

end