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

ActiveRecord::Schema.define(version: 20150702154105) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "cube"
  enable_extension "earthdistance"

  create_table "drivers", force: :cascade do |t|
    t.string   "email"
    t.time     "time"
    t.float    "sourcelat"
    t.float    "sourcelong"
    t.float    "deslat"
    t.float    "deslong"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "driverid"
  end
  execute "CREATE SEQUENCE drivers_driverid_seq START 1"

  create_table "riders", force: :cascade do |t|
    t.string   "email"
    t.time     "time"
    t.float    "sourcelat"
    t.float    "sourcelong"
    t.float    "deslat"
    t.float    "deslong"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.integer  "mobilenumber", limit: 8
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

end
