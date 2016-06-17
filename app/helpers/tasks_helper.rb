module TasksHelper

	def is_task_belongs_current_user?(current_task)

		task = (!current_task.is_a?(Task))? Task.includes(:client, client: :user).find_by_id(current_task) : current_task

		return !task.nil? &&  
			   !task.client.nil? &&
			   !task.client.user.nil? &&
		       !current_user.nil? && 
				task.client.user.id == current_user.id
	end

end
