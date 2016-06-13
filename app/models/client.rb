class Client < ActiveRecord::Base
	
	belongs_to :user
	has_many :tasks, :dependent => :destroy
	
	validates :name, 	presence: true
	validates :fio, 	presence: true
	#validates :site, 	format: { with: /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/}

end
