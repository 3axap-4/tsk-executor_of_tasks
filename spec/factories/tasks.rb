FactoryGirl.define do

	factory :task do
		ignore do
		    client nil
	  	end
		sequence(:title){|i| "Task #{i}"}
		sequence(:description){|i| "Description of task #{i}"}
	end

	factory :task_admin, class: Task do
		ignore do
		    client nil
	  	end
		sequence(:title){|i| "Task #{i}"}
		sequence(:description){|i| "Description of task #{i}"}
	end

end
