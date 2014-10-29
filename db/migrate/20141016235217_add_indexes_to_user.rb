class AddIndexesToUser < ActiveRecord::Migration
  def change
    add_index :users, :fullname
    add_index :users, :username
  end
end
