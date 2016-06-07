class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :fio
      t.string :site
      t.text :description
      t.date :last_in
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
