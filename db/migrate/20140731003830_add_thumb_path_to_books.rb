class AddThumbPathToBooks < ActiveRecord::Migration
  def change
    add_column :books, :thumb_path, :string
  end
end
