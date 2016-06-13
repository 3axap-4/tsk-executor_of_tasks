class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :body, :limit => 12, :null => false
      t.integer :user_id
      t.integer :task_id
      t.timestamps null: false
    end
  end
end
