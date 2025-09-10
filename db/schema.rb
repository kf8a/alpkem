# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_10_25_145546) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.integer "record_id", null: false
    t.integer "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.integer "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "analytes", force: :cascade do |t|
    t.string "name"
    t.string "unit"
  end

  create_table "data_sources", force: :cascade do |t|
    t.integer "run_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "data"
  end

  create_table "measurements", force: :cascade do |t|
    t.integer "run_id"
    t.integer "sample_id"
    t.integer "analyte_id"
    t.float "amount"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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

  create_table "run_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runs", force: :cascade do |t|
    t.date "run_date"
    t.date "sample_date"
    t.integer "sample_type_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "start_date"
    t.text "comment"
    t.date "initial_sample_date"
    t.integer "run_type_id"
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
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "workflow_state"
    t.index ["plot_id"], name: "index_samples_on_plot_id"
    t.index ["sample_date"], name: "index_samples_on_sample_date"
    t.index ["sample_type_id"], name: "index_samples_on_sample_type_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "stations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
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
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "runs", "run_types"
end
