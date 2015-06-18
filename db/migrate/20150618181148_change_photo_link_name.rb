class ChangePhotoLinkName < ActiveRecord::Migration
  def change
    rename_column :users, :photo_link, :photo_link_full
  end
end
