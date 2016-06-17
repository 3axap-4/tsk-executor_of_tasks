module CartItems

	def is_cart_item_belongs_current_user?(current_item)

	item = (!current_item.is_a?(CartItem))? CartItem.includes(:task, task: :client).find_by_id(current_item) : current_item

	return !item.nil? &&  
			   !item.task.nil? &&
			   !item.task.client.nil? &&
			   !item.task.client.user.nil? &&
		       !current_user.nil? && 
				(item.task.client.user.id == current_user.id ||
					current_user.is_admin?)
	end


end