class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :introduction, :string
    add_column :users, :website, :string
    add_column :users, :tel, :string
    add_column :users, :sex, :string
  end
end
