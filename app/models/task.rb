class Task < ActiveRecord::Base
	belongs_to :client
	belongs_to :task_status

	has_one  :cart_item,  	:dependent => :destroy
	has_many :comments,  	:dependent => :destroy
	has_many :attachments, 	:dependent => :destroy
	
	accepts_nested_attributes_for :attachments
	accepts_nested_attributes_for :comments
end
