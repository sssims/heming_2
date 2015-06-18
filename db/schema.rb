# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150618222813) do

  create_table "blurbs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "books", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "author",         limit: 255
    t.string   "publisher",      limit: 255
    t.string   "published_date", limit: 255
    t.string   "isbn",           limit: 255
    t.string   "language",       limit: 255
    t.string   "image_path",     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumb_path",     limit: 255
    t.string   "buy_link"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id"

  create_table "toptens", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.string   "blurb"
    t.integer  "order"
    t.datetime "dateread"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",         limit: 255
    t.string   "fullname",         limit: 255
    t.string   "email",            limit: 255
    t.string   "enc_pword",        limit: 255
    t.string   "salt",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about"
    t.string   "photo_link_full",  limit: 255
    t.boolean  "cred"
    t.string   "photo_link_thumb"
    t.integer  "follower_count"
    t.integer  "following_count"
  end

  add_index "users", ["fullname"], name: "index_users_on_fullname"
  add_index "users", ["username"], name: "index_users_on_username"

end
