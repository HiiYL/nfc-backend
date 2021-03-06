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

ActiveRecord::Schema.define(version: 20141117132402) do

  create_table "updates", force: true do |t|
    t.datetime "time"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "status"
    t.string   "student_id"
    t.string   "card_no"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["card_no"], name: "index_users_on_card_no"
  add_index "users", ["name"], name: "index_users_on_name", unique: true
  add_index "users", ["status"], name: "index_users_on_status"

end
