class AddCredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cred, :boolean
  end
end
