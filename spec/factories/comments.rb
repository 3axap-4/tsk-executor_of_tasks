FactoryGirl.define do

	factory :comment do
		ignore do
		    user nil
		    task nil
	  	end
		sequence(:body){|i| "comment #{i}"}
	end

end