FactoryGirl.define do 
	factory :user do
		sequence :email do |i| 
			"mail#{i}.@mailru" 
		end
	    password "password"
    	password_confirmation "password"
		is_admin false
	end

	factory :admin, class: User do
		sequence :email do |i| 
			"mailadmin#{i}.@mailru" 
		end
	    password "password"
    	password_confirmation "password"
		is_admin true
	end

end