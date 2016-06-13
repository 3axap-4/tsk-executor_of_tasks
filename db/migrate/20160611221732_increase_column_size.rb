class IncreaseColumnSize < ActiveRecord::Migration
  def up
    change_column :comments, :body, :string, :limit => 140
  end

  def down
    change_column :comments, :body, :string, :limit => 12
  end
end
