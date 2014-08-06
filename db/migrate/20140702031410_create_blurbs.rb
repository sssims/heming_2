class CreateBlurbs < ActiveRecord::Migration
  def change
    create_table :blurbs do |t|
      t.integer "user_id"
      t.integer "book_id"
      t.text    "content"

      t.timestamps
    end
  end
end
