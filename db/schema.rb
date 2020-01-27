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

ActiveRecord::Schema.define(version: 2020_01_27_120143) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "game_results", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.bigint "league_id"
    t.integer "score", null: false
    t.integer "calc_score"
    t.integer "rank"
    t.boolean "tobi", null: false
    t.boolean "tobasi", null: false
    t.integer "rate_score"
    t.integer "guest_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_results_on_game_id"
    t.index ["league_id"], name: "index_game_results_on_league_id"
    t.index ["user_id"], name: "index_game_results_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.bigint "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_games_on_league_id"
  end

  create_table "leagues", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "haikyu_genten", null: false
    t.integer "genten", null: false
    t.integer "uma", null: false
    t.integer "tobi", null: false
    t.integer "fraction_process", null: false
    t.integer "tobi_prize", null: false
    t.integer "rate", null: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "league_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_participations_on_league_id"
    t.index ["user_id", "league_id"], name: "index_participations_on_user_id_and_league_id", unique: true
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "following_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "following_id"], name: "index_relationships_on_follower_id_and_following_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
    t.index ["following_id"], name: "index_relationships_on_following_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.integer "haikyu_genten", null: false
    t.integer "genten", null: false
    t.integer "uma", null: false
    t.integer "tobi", null: false
    t.integer "fraction_process", null: false
    t.integer "tobi_prize", null: false
    t.integer "rate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_rules_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "test", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "game_results", "games"
  add_foreign_key "game_results", "leagues"
  add_foreign_key "game_results", "users"
  add_foreign_key "games", "leagues"
  add_foreign_key "rules", "users"
end
