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

ActiveRecord::Schema.define(version: 20170602162700) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "couples", force: :cascade do |t|
    t.string  "first_name", null: false
    t.string  "last_name",  null: false
    t.text    "notes"
    t.integer "event_id",   null: false
    t.index ["event_id"], name: "index_couples_on_event_id", using: :btree
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",             null: false
    t.integer  "table_size_limit", null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "side_a"
    t.integer  "side_b"
  end

  create_table "guests", force: :cascade do |t|
    t.string  "first_name",      null: false
    t.string  "last_name",       null: false
    t.integer "side",            null: false
    t.text    "notes"
    t.integer "relationship_id", null: false
    t.integer "event_id",        null: false
    t.integer "table_id"
    t.index ["event_id"], name: "index_guests_on_event_id", using: :btree
    t.index ["relationship_id"], name: "index_guests_on_relationship_id", using: :btree
  end

  create_table "hosts", id: false, force: :cascade do |t|
    t.integer "event_id", null: false
    t.integer "user_id",  null: false
  end

  create_table "plusones", force: :cascade do |t|
    t.string  "first_name", null: false
    t.string  "last_name",  null: false
    t.integer "guest_id"
    t.text    "notes"
    t.integer "table_id"
    t.index ["guest_id"], name: "index_plusones_on_guest_id", using: :btree
  end

  create_table "relationships", force: :cascade do |t|
    t.string  "name",                      null: false
    t.integer "event_id"
    t.boolean "universal", default: false
    t.index ["event_id"], name: "index_relationships_on_event_id", using: :btree
  end

  create_table "tables", force: :cascade do |t|
    t.integer "table_number",     null: false
    t.integer "table_size_limit", null: false
    t.integer "event_id"
    t.index ["event_id"], name: "index_tables_on_event_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                          null: false
    t.string   "last_name",                           null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
