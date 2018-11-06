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

ActiveRecord::Schema.define(version: 2018_11_06_114621) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "authorizations", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 8, scale: 2
    t.integer "user_id", null: false
    t.string "ip"
    t.string "payment_id"
    t.integer "status"
    t.string "currency"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "coupon"
    t.string "checkout_id"
    t.string "payment_method"
    t.string "receipt_url"
    t.string "subscription_id"
    t.index ["payment_id"], name: "index_orders_on_payment_id"
    t.index ["payment_method"], name: "index_orders_on_payment_method"
    t.index ["subscription_id"], name: "index_orders_on_subscription_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug", null: false
    t.integer "created_by"
    t.string "pv"
    t.float "timer"
    t.integer "stories_count"
    t.integer "user_rooms_count"
    t.integer "style"
    t.float "duration"
    t.string "scheme"
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

  create_table "stories", id: :serial, force: :cascade do |t|
    t.integer "room_id"
    t.string "link"
    t.text "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "point"
    t.integer "sequence"
    t.datetime "discarded_at"
    t.index ["discarded_at"], name: "index_stories_on_discarded_at"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "subscription_id"
    t.string "subscription_plan_id"
    t.string "update_url"
    t.string "cancel_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_id"], name: "index_subscriptions_on_subscription_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "user_rooms", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role"
    t.index ["room_id"], name: "index_user_rooms_on_room_id"
    t.index ["user_id", "room_id"], name: "index_user_rooms_on_user_id_and_room_id", unique: true
  end

  create_table "user_story_points", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "story_id"
    t.string "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "comment"
    t.boolean "finalized"
    t.index ["finalized"], name: "index_user_story_points_on_finalized"
    t.index ["story_id"], name: "index_user_story_points_on_story_id"
    t.index ["user_id", "story_id"], name: "index_user_story_points_on_user_id_and_story_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string "image"
    t.datetime "premium_expiration"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
