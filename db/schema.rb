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

ActiveRecord::Schema.define(version: 2020_02_11_181417) do

  create_table "chip_results", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "chip_id"
    t.integer "guest_num"
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "score"
    t.integer "rate_score"
    t.index ["chip_id"], name: "index_chip_results_on_chip_id"
    t.index ["user_id"], name: "index_chip_results_on_user_id"
  end

  create_table "chips", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_chips_on_league_id"
  end

  create_table "game_results", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "game_id"
    t.bigint "league_id"
    t.integer "score", null: false
    t.integer "calc_score"
    t.integer "rank"
    t.boolean "tobi", default: false, null: false
    t.boolean "tobasi", default: false, null: false
    t.integer "rate_score"
    t.integer "guest_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_results_on_game_id"
    t.index ["league_id"], name: "index_game_results_on_league_id"
    t.index ["user_id"], name: "index_game_results_on_user_id"
  end

  create_table "games", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "league_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_games_on_league_id"
  end

  create_table "leagues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "haikyu_genten", null: false
    t.integer "genten", null: false
    t.integer "uma", null: false
    t.integer "tobi", null: false
    t.integer "fraction_process", null: false
    t.integer "tobi_prize", null: false
    t.integer "rate", null: false
    t.integer "guests_num", default: 0, null: false
    t.integer "chip", null: false
    t.integer "chip_rate", null: false
  end

  create_table "participations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "league_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["league_id"], name: "index_participations_on_league_id"
    t.index ["user_id", "league_id"], name: "index_participations_on_user_id_and_league_id", unique: true
    t.index ["user_id"], name: "index_participations_on_user_id"
  end

  create_table "relationships", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "follower_id", null: false
    t.integer "following_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["follower_id", "following_id"], name: "index_relationships_on_follower_id_and_following_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
    t.index ["following_id"], name: "index_relationships_on_following_id"
  end

  create_table "rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id"
    t.integer "haikyu_genten", default: 25000, null: false
    t.integer "genten", default: 30000, null: false
    t.integer "uma", default: 2, null: false
    t.integer "tobi", default: 1, null: false
    t.integer "fraction_process", default: 5, null: false
    t.integer "tobi_prize", default: 10000, null: false
    t.integer "rate", default: 50, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "chip", default: 0, null: false
    t.integer "chip_rate", default: 2000, null: false
    t.index ["user_id"], name: "index_rules_on_user_id"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "test", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_digest"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  add_foreign_key "chip_results", "chips"
  add_foreign_key "chip_results", "users"
  add_foreign_key "chips", "leagues"
  add_foreign_key "game_results", "games"
  add_foreign_key "game_results", "leagues"
  add_foreign_key "game_results", "users"
  add_foreign_key "games", "leagues"
  add_foreign_key "rules", "users"
end
