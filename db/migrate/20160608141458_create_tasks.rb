class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.integer :client_id
      t.integer :task_status_id
      t.timestamps null: false
    end
  end
end
