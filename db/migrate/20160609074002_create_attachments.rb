class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.integer :task_id
      t.string :source

      t.timestamps null: false
    end
  end
end
