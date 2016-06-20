class Task < ActiveRecord::Base
	belongs_to :client
	belongs_to :task_status

	has_one  :cart_item,  	:dependent => :destroy
	has_many :comments,  	:dependent => :destroy
	has_many :attachments, 	:dependent => :destroy
	
	accepts_nested_attributes_for :attachments
	accepts_nested_attributes_for :comments

	validates :client_id, 		presence: true
	validates :task_status_id,  presence: true
	validates :title, 			presence: true
	validates_numericality_of 	:price, greater_than_or_equal_to: 0
end
