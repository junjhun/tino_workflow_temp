class CreateCoats < ActiveRecord::Migration[7.0]
  def change
    create_table :coats do |t|
      t.integer :order_id
      t.string :jacket_length
      t.string :back_width
      t.string :sleeves
      t.string :cuffs_1
      t.string :cuffs_2
      t.string :collar
      t.string :chest
      t.string :waist
      t.string :hips
      t.integer :stature
      t.integer :shoulders
      t.text :remarks

      t.timestamps
    end
  end
end
