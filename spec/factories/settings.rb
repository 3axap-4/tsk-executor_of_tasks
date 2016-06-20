FactoryGirl.define do

	factory :setting do
		name 'default_task_type_id'
		value { (FactoryGirl.create(:task_status)).id } 
	end

end