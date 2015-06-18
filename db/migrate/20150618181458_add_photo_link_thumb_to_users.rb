class AddPhotoLinkThumbToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo_link_thumb, :string
  end
end
