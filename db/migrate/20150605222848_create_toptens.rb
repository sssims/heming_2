class CreateToptens < ActiveRecord::Migration
  def change
    create_table :toptens do |t|
      t.integer :user_id
      t.integer :book_id
      t.string :blurb
      t.integer :order
      t.datetime :dateread

      t.timestamps null: false
    end
  end
end
