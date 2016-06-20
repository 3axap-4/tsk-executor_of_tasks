FactoryGirl.define do

	factory :task do
		sequence(:title){|i| "Task #{i}"}
		sequence(:description){|i| "Description of task #{i}"}
		task_status_id { (FactoryGirl.create(:task_status)).id } 
		price 0
	end

	factory :task_admin, class: Task do
		ignore do
		    client nil
	  	end
		sequence(:title){|i| "Task #{i}"}
		sequence(:description){|i| "Description of task #{i}"}
		price 0
	end

end
