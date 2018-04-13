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

ActiveRecord::Schema.define(version: 2018_04_12_212545) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "carpools", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "from_city_id"
    t.integer "to_city_id"
    t.text "note"
    t.datetime "deleted_at"
    t.boolean "full", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_carpools_on_deleted_at"
    t.index ["user_id"], name: "index_carpools_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "place_id"
    t.string "name"
    t.string "state"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["latitude", "longitude"], name: "index_cities_on_latitude_and_longitude"
    t.index ["name", "state"], name: "index_cities_on_name_and_state", unique: true
    t.index ["place_id"], name: "index_cities_on_place_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "facebook_user_id"
    t.string "phone_number"
    t.string "phone_country_prefix"
    t.string "phone_national_number"
    t.boolean "verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facebook_user_id"], name: "index_users_on_facebook_user_id", unique: true
  end

end
