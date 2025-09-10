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

ActiveRecord::Schema[7.1].define(version: 2025_09_10_160758) do
  create_schema "aglog"
  create_schema "alpkem"
  create_schema "ants"
  create_schema "aquatic"
  create_schema "area_description"
  create_schema "bonnie"
  create_schema "data"
  create_schema "enviro_weather"
  create_schema "gis"
  create_schema "glbrc"
  create_schema "glbrc_inorganic_n"
  create_schema "glbrc_marginal_experiment"
  create_schema "glbrc_marginal_species"
  create_schema "glbrc_mle_moisture"
  create_schema "glbrc_other_experiments"
  create_schema "glbrc_roots"
  create_schema "glbrc_scaleup"
  create_schema "hamilton"
  create_schema "hamilton_water_samples"
  create_schema "ilya_bnf"
  create_schema "insects"
  create_schema "kbs004"
  create_schema "kbs006"
  create_schema "kbs011"
  create_schema "kbs013"
  create_schema "kbs015"
  create_schema "kbs017"
  create_schema "kbs018"
  create_schema "kbs019"
  create_schema "kbs020"
  create_schema "kbs021"
  create_schema "kbs022"
  create_schema "kbs023"
  create_schema "kbs024"
  create_schema "kbs025"
  create_schema "kbs026"
  create_schema "kbs028"
  create_schema "kbs029"
  create_schema "kbs030"
  create_schema "kbs032"
  create_schema "kbs033"
  create_schema "kbs034"
  create_schema "kbs037"
  create_schema "kbs038"
  create_schema "kbs039"
  create_schema "kbs040"
  create_schema "kbs041"
  create_schema "kbs042"
  create_schema "kbs043"
  create_schema "kbs044"
  create_schema "kbs046"
  create_schema "kbs047"
  create_schema "kbs049"
  create_schema "kbs050"
  create_schema "kbs052"
  create_schema "kbs053"
  create_schema "kbs055"
  create_schema "kbs056"
  create_schema "kbs057"
  create_schema "kbs059"
  create_schema "kbs061"
  create_schema "kbs062"
  create_schema "kbs076"
  create_schema "kbs080"
  create_schema "kbs081"
  create_schema "kbs082"
  create_schema "kbs083"
  create_schema "kbs086"
  create_schema "kbs097"
  create_schema "kbs100"
  create_schema "kbs102"
  create_schema "kbs106"
  create_schema "kbs109"
  create_schema "kbs_farm"
  create_schema "ltar"
  create_schema "lter"
  create_schema "lter_roots"
  create_schema "metadata"
  create_schema "micos_remote"
  create_schema "modeling"
  create_schema "n_tier_dataset"
  create_schema "odm"
  create_schema "poplar_fertilization_experiment"
  create_schema "projects"
  create_schema "rasters"
  create_schema "registrations"
  create_schema "ruan_thesis"
  create_schema "spatial_yield"
  create_schema "student"
  create_schema "surf_remote"
  create_schema "surveys"
  create_schema "tdr"
  create_schema "temp"
  create_schema "test"
  create_schema "topology"
  create_schema "trailer_icos"
  create_schema "weather"
  create_schema "webgas"
  create_schema "yield_monitor"

  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gist"
  enable_extension "fuzzystrmatch"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_raster"
  enable_extension "postgis_topology"
  enable_extension "postgres_fdw"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
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
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "analytes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "unit", limit: 255
  end

  create_table "cn_measurements", id: :serial, comment: "deprecated in favor of measurements", force: :cascade do |t|
    t.integer "run_id"
    t.integer "cn_sample_id"
    t.integer "analyte_id"
    t.float "amount"
    t.boolean "deleted", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["analyte_id"], name: "index_cn_measurements_on_analyte_id"
    t.index ["cn_sample_id"], name: "index_cn_measurements_on_cn_sample_id"
    t.index ["run_id"], name: "index_cn_measurements_on_run_id"
  end

  create_table "cn_samples", id: :serial, comment: "deprecated in favor of samples", force: :cascade do |t|
    t.string "cn_plot", limit: 255
    t.date "sample_date"
    t.boolean "approved", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "data_sources", id: :serial, force: :cascade do |t|
    t.integer "run_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "data", limit: 255
  end

  create_table "flags", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.bigint "sample_id", null: false
    t.string "flag", limit: 255
    t.text "comment"
    t.index ["sample_id"], name: "flags_index_2", unique: true
  end

  create_table "measurements", id: :serial, force: :cascade do |t|
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

  create_table "plots", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "study_id"
    t.integer "treatment_id"
    t.integer "replicate_id"
    t.text "species_code"
    t.text "fraction"
    t.float "top_depth"
    t.float "bottom_depth"
    t.integer "station_id"
    t.text "sub_plot"
    t.text "treatment_name"
    t.text "replicate_name"
    t.text "station_name"
    t.datetime "created_at", precision: nil, default: -> { "now()" }
    t.datetime "updated_at", precision: nil, default: -> { "now()" }
    t.string "site_code", limit: 2
    t.index ["name", "study_id"], name: "plots_name_study_id_idx", unique: true
    t.unique_constraint ["name", "study_id"], name: "plots_name_study_id_key"
  end

  create_table "replicates", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "study_id"
  end

  create_table "run_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runs", id: :serial, force: :cascade do |t|
    t.date "run_date"
    t.date "sample_date"
    t.integer "sample_type_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.date "start_date"
    t.text "comment"
    t.date "initial_sample_date"
    t.integer "run_type_id", null: false
    t.index ["sample_type_id"], name: "index_runs_on_sample_type_id"
  end

  create_table "sample_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "active", default: true
    t.text "parser"
    t.integer "study_id"
    t.text "comment"
  end

  create_table "samples", id: :serial, comment: "approved boolean is deprecated and can be deleted", force: :cascade do |t|
    t.integer "plot_id"
    t.integer "sample_type_id"
    t.date "sample_date"
    t.boolean "approved", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "workflow_state", limit: 255
    t.text "comments"
    t.index ["plot_id"], name: "index_samples_on_plot_id"
    t.index ["sample_date"], name: "index_samples_on_sample_date"
    t.index ["sample_type_id"], name: "index_samples_on_sample_type_id"
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "stations", id: :serial, force: :cascade do |t|
    t.text "name"

    t.unique_constraint ["name"], name: "stations_name_key"
  end

  create_table "studies", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "prefix", limit: 255
  end

  create_table "temp_mineralization_dates", id: false, comment: "sarah mineralization", force: :cascade do |t|
    t.date "initial_date"
    t.date "final_date"
  end

  create_table "treatments", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "study_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "identity_url", limit: 255
    t.string "remember_token", limit: 255
    t.datetime "remember_created_at", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.index ["identity_url"], name: "index_users_on_identity_url", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "flags", "samples", name: "flags_relation_1"
  add_foreign_key "measurements", "samples", name: "measurements_sample_id_fkey"
  add_foreign_key "plots", "glbrc_marginal_experiment.mle_site_codes", column: "site_code", primary_key: "code", name: "plots_site_code_fkey", validate: false
  add_foreign_key "plots", "kbs019.kbs_plant_codes", column: "species_code", primary_key: "code", name: "plots_species_code_fkey", validate: false
  add_foreign_key "runs", "run_types"
  add_foreign_key "samples", "plots", name: "samples_plot_id_fkey"
  add_foreign_key "samples", "sample_types", name: "samples_sample_types_fk"
end
