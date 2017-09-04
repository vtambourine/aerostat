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

ActiveRecord::Schema.define(version: 20170903210808) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.string "raw_name"
    t.string "name_hash"
    t.boolean "is_reviewed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name_hash"], name: "index_artists_on_name_hash", unique: true
  end

  create_table "tracks", force: :cascade do |t|
    t.bigint "artist_id"
    t.string "title"
    t.time "duration"
    t.string "label"
    t.string "error"
    t.string "raw_title"
    t.string "title_hash"
    t.boolean "is_reviewed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id", "title"], name: "index_tracks_on_artist_and_title"
    t.index ["artist_id"], name: "index_tracks_on_artist_id"
  end

  create_table "tracks_volumes", id: false, force: :cascade do |t|
    t.bigint "track_id"
    t.bigint "volume_id"
    t.index ["track_id"], name: "index_tracks_volumes_on_track_id"
    t.index ["volume_id"], name: "index_tracks_volumes_on_issue_id"
  end

  create_table "volumes", force: :cascade do |t|
    t.integer "number"
    t.string "title"
    t.string "raw_title"
    t.date "published_at"
    t.text "text"
    t.integer "duration"
    t.string "aquarium_url"
    t.string "aerostatica_url"
    t.string "title_hash"
    t.boolean "is_reviewed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_volumes_on_number", unique: true
  end

end
