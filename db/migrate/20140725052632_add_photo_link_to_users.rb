class AddPhotoLinkToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo_link, :string
  end
end
