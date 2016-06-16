FactoryGirl.define do 
	factory :cart_item do
		ignore do
			cart nil
			task nil
		end
	end
end