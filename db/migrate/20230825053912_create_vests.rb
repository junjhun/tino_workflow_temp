class CreateVests < ActiveRecord::Migration[7.0]
  def change
    create_table :vests do |t|
      t.integer :order_id
      t.string :side_pocket
      t.string :chest_pocket
      t.string :vest_length
      t.string :back_width
      t.string :chest
      t.string :waist
      t.string :hips

      t.timestamps
    end
  end
end
