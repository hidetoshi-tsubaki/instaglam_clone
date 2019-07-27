class AddDefaultCheckedToUser < ActiveRecord::Migration[5.1]
  def change
    change_column :notifications, :checked, :boolean, :default => false
  end
end
