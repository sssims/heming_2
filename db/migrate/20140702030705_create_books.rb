class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string "title"
      t.string "author"
      t.string "publisher"
      t.string "published_date"
      t.string "isbn"
      t.string "language"
      t.string "image_path" #local storage
 
      t.timestamps
    end
  end
end
