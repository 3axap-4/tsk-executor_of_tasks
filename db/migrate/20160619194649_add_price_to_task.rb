class AddPriceToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :price, :decimal, precision: 8, scale: 2, default: 0, null: false
  end
end
