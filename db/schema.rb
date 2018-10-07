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

ActiveRecord::Schema.define(version: 2018_10_07_045803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.string "access_token", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "name", limit: 191, null: false
    t.bigint "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", limit: 255, null: false
    t.bigint "created_by"
    t.string "pv", limit: 255
    t.float "timer"
    t.bigint "stories_count"
    t.bigint "user_rooms_count"
    t.bigint "style"
    t.string "scheme", limit: 255
    t.float "duration"
    t.datetime "discarded_at"
    t.index ["created_by"], name: "index_rooms_on_created_by"
    t.index ["discarded_at"], name: "index_rooms_on_discarded_at"
    t.index ["name"], name: "index_rooms_on_name"
    t.index ["slug"], name: "index_rooms_on_slug", unique: true
  end

  create_table "schemes", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "points", null: false, array: true
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_schemes_on_slug", unique: true
    t.index ["user_id"], name: "index_schemes_on_user_id"
  end

  create_table "stories", force: :cascade do |t|
    t.bigint "room_id"
    t.string "link", limit: 255
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "point", limit: 255
    t.bigint "sequence"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_stories_on_discarded_at"
  end

  create_table "user_rooms", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role"
    t.index ["room_id"], name: "index_user_rooms_on_room_id"
    t.index ["user_id", "room_id"], name: "index_user_rooms_on_user_id_and_room_id", unique: true
  end

  create_table "user_story_points", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "story_id"
    t.string "points", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.boolean "finalized"
    t.index ["finalized"], name: "index_user_story_points_on_finalized"
    t.index ["story_id"], name: "index_user_story_points_on_story_id"
    t.index ["user_id", "story_id"], name: "index_user_story_points_on_user_id_and_story_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 255
    t.bigint "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "avatar_file_name", limit: 255
    t.string "avatar_content_type", limit: 255
    t.bigint "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "image", limit: 255
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
