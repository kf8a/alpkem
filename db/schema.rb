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

ActiveRecord::Schema.define(version: 2015_02_20_213420) do

  create_table "analytes", force: :cascade do |t|
    t.string "name"
    t.string "unit"
  end

  create_table "data_sources", force: :cascade do |t|
    t.integer "run_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "data"
  end

  create_table "measurements", force: :cascade do |t|
    t.integer "run_id"
    t.integer "sample_id"
    t.integer "analyte_id"
    t.float "amount"
    t.boolean "deleted", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "rejected", default: false
    t.index ["analyte_id"], name: "index_measurements_on_analyte_id"
    t.index ["run_id"], name: "index_measurements_on_run_id"
    t.index ["sample_id"], name: "index_measurements_on_sample_id"
  end

  create_table "plots", force: :cascade do |t|
    t.string "name"
    t.integer "study_id"
    t.integer "treatment_id"
    t.integer "replicate_id"
    t.string "species_code"
    t.float "top_depth"
    t.float "bottom_depth"
    t.integer "station_id"
    t.text "sub_plot"
    t.text "treatment"
    t.text "replicate"
  end

  create_table "replicates", force: :cascade do |t|
    t.string "name"
    t.integer "study_id"
  end

  create_table "runs", force: :cascade do |t|
    t.date "run_date"
    t.date "sample_date"
    t.integer "sample_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "start_date"
    t.text "comment"
    t.date "initial_sample_date"
    t.index ["sample_type_id"], name: "index_runs_on_sample_type_id"
  end

  create_table "sample_types", force: :cascade do |t|
    t.string "name"
    t.boolean "active", default: true
    t.text "parser"
    t.integer "study_id"
  end

  create_table "samples", force: :cascade do |t|
    t.integer "plot_id"
    t.integer "sample_type_id"
    t.date "sample_date"
    t.boolean "approved", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "workflow_state"
    t.index ["plot_id"], name: "index_samples_on_plot_id"
    t.index ["sample_date"], name: "index_samples_on_sample_date"
    t.index ["sample_type_id"], name: "index_samples_on_sample_type_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "studies", force: :cascade do |t|
    t.string "name"
    t.string "prefix"
  end

  create_table "treatments", force: :cascade do |t|
    t.string "name"
    t.integer "study_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
  end

end
