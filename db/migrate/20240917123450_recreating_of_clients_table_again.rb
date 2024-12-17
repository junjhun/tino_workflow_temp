class RecreatingOfClientsTableAgain < ActiveRecord::Migration[7.0]
  def change
    drop_table :clients

    create_table :clients do |t|
      t.string "name"
      t.string "contact"
      t.string "email"
      t.string "IG_handle"
      t.text "address"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "how_did_you_learn_about_us"
      t.string "referred_by"
      t.float "shoe_size"
      t.integer "gender", default: 0, null: false
      t.string "assisted_by"
      t.string "measured_by"
    end
  end
end
