FactoryGirl.define do
	factory :task do
		assosiation (:user)
		sequence(:title){|i| "Task #{i}"}
		sequence(:description){|i| "Description of task #{i}"}
	end
end