class DeleteTaskFromCarts < ActiveRecord::Migration
  def up
  	remove_column :carts, :task_id
  end

  def down
	add_column :carts, :task_id
  end
end
