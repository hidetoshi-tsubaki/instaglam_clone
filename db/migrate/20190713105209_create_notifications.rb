class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :reciever_id
      t.integer :post_id
      t.integer :comment_id
      t.string :action
      t.boolean :checked
      t.timestamps
    end
  end
end
