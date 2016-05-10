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

  create_table "analytes", force: :cascade do |t|
    t.string "name"
    t.string "unit"
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

  add_index "cn_measurements", ["analyte_id"], name: "index_cn_measurements_on_analyte_id"
  add_index "cn_measurements", ["cn_sample_id"], name: "index_cn_measurements_on_cn_sample_id"
  add_index "cn_measurements", ["run_id"], name: "index_cn_measurements_on_run_id"

  create_table "cn_samples", force: :cascade do |t|
    t.string   "cn_plot"
    t.date     "sample_date"
    t.boolean  "approved",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "data_sources", force: :cascade do |t|
    t.integer  "run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "data"
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

  add_index "measurements", ["analyte_id"], name: "index_measurements_on_analyte_id"
  add_index "measurements", ["run_id"], name: "index_measurements_on_run_id"
  add_index "measurements", ["sample_id"], name: "index_measurements_on_sample_id"

  create_table "open_id_authentication_associations", force: :cascade do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", force: :cascade do |t|
    t.integer "timestamp",  null: false
    t.string  "server_url"
    t.string  "salt",       null: false
  end

  create_table "plots", force: :cascade do |t|
    t.string  "name"
    t.integer "study_id"
    t.integer "treatment_id"
    t.integer "replicate_id"
    t.string  "species_code"
    t.text    "sub_plot"
    t.text    "treatment"
    t.text    "replicate"
  end

  create_table "replicates", force: :cascade do |t|
    t.string  "name"
    t.integer "study_id"
  end

  create_table "runs", force: :cascade do |t|
    t.date     "run_date"
    t.date     "sample_date"
    t.integer  "sample_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "initial_sample_date"
  end

  add_index "runs", ["sample_type_id"], name: "index_runs_on_sample_type_id"

  create_table "sample_types", force: :cascade do |t|
    t.string  "name"
    t.boolean "active",   default: true
    t.text    "parser"
    t.integer "study_id"
  end

  create_table "samples", force: :cascade do |t|
    t.integer  "plot_id"
    t.integer  "sample_type_id"
    t.date     "sample_date"
    t.boolean  "approved",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "workflow_state"
  end

  add_index "samples", ["plot_id"], name: "index_samples_on_plot_id"
  add_index "samples", ["sample_date"], name: "index_samples_on_sample_date"
  add_index "samples", ["sample_type_id"], name: "index_samples_on_sample_type_id"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "studies", force: :cascade do |t|
    t.string "name"
    t.string "prefix"
  end

  create_table "treatments", force: :cascade do |t|
    t.string  "name"
    t.integer "study_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

end
