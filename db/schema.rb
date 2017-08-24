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

ActiveRecord::Schema.define(version: 20170823210103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "issues", force: :cascade do |t|
    t.integer "number"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "text"
    t.integer "duration"
    t.text "source"
    t.date "date"
    t.index ["number"], name: "index_issues_on_number", unique: true
  end

  create_table "issues_tracks", id: false, force: :cascade do |t|
    t.bigint "issue_id"
    t.bigint "track_id"
    t.index ["issue_id"], name: "index_issues_tracks_on_issue_id"
    t.index ["track_id"], name: "index_issues_tracks_on_track_id"
  end

  create_table "tracks", force: :cascade do |t|
    t.string "artist"
    t.string "title"
    t.time "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
