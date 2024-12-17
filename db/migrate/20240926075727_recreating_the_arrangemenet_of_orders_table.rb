class RecreatingTheArrangemenetOfOrdersTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :orders

    create_table "orders", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "status", default: 0, null: false
      t.integer "client_id"
      t.integer "purpose", default: 0, null: false
      t.date "first_fitting"
      t.date "second_fitting"
      t.date "third_fitting"
      t.date "fourth_fitting"
      t.date "finish"
      t.string "jo_number"
      t.integer "brand_name"
      t.integer "type_of_service", default: 0, null: false
      t.string "item_type"
    end 
  end
end
