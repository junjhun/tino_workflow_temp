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

ActiveRecord::Schema[7.0].define(version: 2023_08_07_022808) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "contact"
    t.string "email"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coats", force: :cascade do |t|
    t.integer "order_id"
    t.string "jacket_length"
    t.string "back_width"
    t.string "sleeves"
    t.string "cuffs_1"
    t.string "cuffs_2"
    t.string "collar"
    t.string "chest"
    t.string "waist"
    t.string "hips"
    t.integer "stature"
    t.integer "shoulders"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "fabric_code"
    t.string "lining_code"
    t.integer "style"
    t.integer "collar_style"
    t.integer "back"
    t.integer "lining"
    t.integer "sleeves_and_padding"
    t.integer "button"
    t.integer "sleeve_buttons"
    t.integer "boutonniere"
    t.string "boutonniere_color"
    t.string "boutonniere_thread_code"
    t.integer "button_spacing"
    t.integer "shoulder_pocket"
    t.integer "coat_pockets"
    t.string "no_of_buttons"
    t.integer "quantity", default: 0, null: false
    t.integer "breast", default: 0, null: false
    t.string "notch"
    t.string "vent"
    t.string "double_breasted"
    t.string "peak"
    t.string "shawl"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.integer "client_id"
    t.string "purpose"
    t.integer "MTO_labor"
    t.date "first_fitting"
    t.date "second_fitting"
    t.date "finish"
    t.string "jo_number"
  end

  create_table "pants", force: :cascade do |t|
    t.integer "order_id"
    t.string "crotch"
    t.string "outsteam"
    t.string "waist"
    t.string "seat"
    t.string "thigh"
    t.string "knee"
    t.string "bottom"
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "quantity", default: 0, null: false
    t.string "fabric_code"
    t.string "lining_code"
    t.integer "pleats", default: 0, null: false
  end

  create_table "shirts", force: :cascade do |t|
    t.string "fabric_label"
    t.string "brand_label"
    t.string "tafetta"
    t.string "fabric_code"
    t.string "lining_code"
    t.string "remarks"
    t.integer "cuffs", default: 0, null: false
    t.integer "pleats", default: 0, null: false
    t.integer "placket", default: 0, null: false
    t.integer "sleeves", default: 0, null: false
    t.integer "pocket", default: 0, null: false
    t.integer "collar", default: 0, null: false
    t.integer "bottom", default: 0, null: false
    t.integer "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_buttons", default: 0, null: false
    t.integer "shirting_barong", default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
