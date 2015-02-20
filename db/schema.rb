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

ActiveRecord::Schema.define(version: 20150220213420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyses", force: :cascade do |t|
    t.integer  "measurement_id"
    t.integer  "sample_id"
    t.integer  "analyte_id"
    t.string   "workflow_state"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "analytes", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "unit", limit: 255
  end

  create_table "cn_measurements", force: :cascade do |t|
    t.integer  "run_id"
    t.integer  "cn_sample_id"
    t.integer  "analyte_id"
    t.float    "amount"
    t.boolean  "deleted",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cn_measurements", ["analyte_id"], name: "index_cn_measurements_on_analyte_id", using: :btree
  add_index "cn_measurements", ["cn_sample_id"], name: "index_cn_measurements_on_cn_sample_id", using: :btree
  add_index "cn_measurements", ["run_id"], name: "index_cn_measurements_on_run_id", using: :btree

  create_table "cn_samples", force: :cascade do |t|
    t.string   "cn_plot",     limit: 255
    t.date     "sample_date"
    t.boolean  "approved",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_sources", force: :cascade do |t|
    t.integer  "run_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "data",       limit: 255
  end

  create_table "measurements", force: :cascade do |t|
    t.integer  "run_id"
    t.integer  "sample_id"
    t.integer  "analyte_id"
    t.float    "amount"
    t.boolean  "deleted",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "rejected",   default: false
  end

  add_index "measurements", ["analyte_id"], name: "index_measurements_on_analyte_id", using: :btree
  add_index "measurements", ["run_id"], name: "index_measurements_on_run_id", using: :btree
  add_index "measurements", ["sample_id"], name: "index_measurements_on_sample_id", using: :btree

  create_table "plots", force: :cascade do |t|
    t.string  "name",         limit: 255
    t.integer "study_id"
    t.integer "treatment_id"
    t.integer "replicate_id"
    t.text    "species_code"
    t.text    "fraction"
    t.float   "top_depth"
    t.float   "bottom_depth"
    t.integer "station_id"
    t.text    "sub_plot"
    t.text    "treatment"
    t.text    "replicate"
  end

  add_index "plots", ["name"], name: "plots_name_key", unique: true, using: :btree

  create_table "replicates", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.integer "study_id"
  end

  create_table "runs", force: :cascade do |t|
    t.date     "run_date"
    t.date     "sample_date"
    t.integer  "sample_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.text     "comment"
    t.date     "initial_sample_date"
  end

  add_index "runs", ["sample_type_id"], name: "index_runs_on_sample_type_id", using: :btree

  create_table "sample_types", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.boolean "active",               default: true
    t.text    "parser"
    t.integer "study_id"
  end

  create_table "samples", force: :cascade do |t|
    t.integer  "plot_id"
    t.integer  "sample_type_id"
    t.date     "sample_date"
    t.boolean  "old_approved",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state", limit: 255
  end

  add_index "samples", ["plot_id"], name: "index_samples_on_plot_id", using: :btree
  add_index "samples", ["sample_date"], name: "index_samples_on_sample_date", using: :btree
  add_index "samples", ["sample_type_id"], name: "index_samples_on_sample_type_id", using: :btree

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255, null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "stations", force: :cascade do |t|
    t.text "name"
  end

  add_index "stations", ["name"], name: "stations_name_key", unique: true, using: :btree

  create_table "studies", force: :cascade do |t|
    t.string "name",   limit: 255
    t.string "prefix", limit: 255
  end

  create_table "treatments", force: :cascade do |t|
    t.string  "name",     limit: 255
    t.integer "study_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "identity_url",           limit: 255
    t.string   "remember_token",         limit: 255
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
  end

  add_index "users", ["identity_url"], name: "index_users_on_identity_url", unique: true, using: :btree

  add_foreign_key "measurements", "samples", name: "measurements_sample_id_fkey"
  add_foreign_key "samples", "plots", name: "samples_plot_id_fkey"
end
