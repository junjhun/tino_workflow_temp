class CreateShirts < ActiveRecord::Migration[7.0]
  def change
    create_table :shirts do |t|
      t.string :fabric_label
      t.string :brand_label
      t.string :tafetta
      t.string :fabric_code
      t.string :lining_code
      t.string :remarks
      t.integer :cuffs, default: 0, null: false
      t.integer :pleats, default: 0, null: false
      t.integer :placket, default: 0, null: false
      t.integer :sleeves, default: 0, null: false
      t.integer :pocket, default: 0, null: false
      t.integer :collar, default: 0, null: false
      t.integer :bottom, default: 0, null: false
      t.integer :order_id

      t.timestamps
    end
  end
end
