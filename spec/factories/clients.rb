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

	factory :client_with_costom_user, class: Client do
		ignore do
			user nil
		end
		name "CustomClient"
		fio "SomeCustomFio"
	end

end