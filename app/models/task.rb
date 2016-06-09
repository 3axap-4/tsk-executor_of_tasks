class Task < ActiveRecord::Base
	belongs_to :client
	belongs_to :task_status

	has_many :attachments, :dependent => :destroy
	accepts_nested_attributes_for :attachments
end
