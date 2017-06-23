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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121114074147) do

  create_table "linked_accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
    t.string   "name"
    t.string   "nickname"
    t.string   "fb_token"
  end

  add_index "linked_accounts", ["user_id"], :name => "index_linked_accounts_on_user_id"

  create_table "links", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "upload_path"
    t.string   "url"
    t.float    "price"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "identity_key"
    t.boolean  "active",            :default => true
    t.boolean  "deleted",           :default => false
    t.string   "unique_url"
    t.integer  "store_id"
    t.integer  "file_ext"
    t.integer  "views"
    t.float    "total_sales"
    t.text     "file_description"
    t.string   "preview_file_path"
    t.text     "description"
  end

  add_index "links", ["user_id", "store_id"], :name => "index_links_on_user_id_and_store_id"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "fullname"
    t.string   "bio"
    t.string   "username"
    t.string   "settings"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "purchase_transactions", :force => true do |t|
    t.integer  "purchase_id"
    t.text     "response_data"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "link_id"
  end

  add_index "purchase_transactions", ["purchase_id", "link_id"], :name => "index_purchase_transactions_on_purchase_id_and_link_id"

  create_table "purchases", :force => true do |t|
    t.integer  "link_id"
    t.integer  "user_id"
    t.boolean  "successful"
    t.integer  "state"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "token"
    t.string   "email"
    t.string   "unique_download_key"
    t.integer  "views"
    t.string   "link_name"
    t.float    "link_price"
  end

  add_index "purchases", ["link_id", "user_id"], :name => "index_purchases_on_link_id_and_user_id"

  create_table "stores", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "visits"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stores", ["user_id"], :name => "index_stores_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.float    "balance"
    t.boolean  "verified_email",     :default => false
    t.string   "verification_key"
    t.integer  "role"
    t.boolean  "has_linked_account"
  end

end
