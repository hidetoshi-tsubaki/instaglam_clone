class AddNotificationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notification, :boolean, default:false, null: false
  end
end
