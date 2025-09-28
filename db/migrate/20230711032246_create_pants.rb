class CreatePants < ActiveRecord::Migration[7.0]
  def change
    create_table :pants do |t|
      t.integer :order_id
      t.string :crotch
      t.string :outsteam
      t.string :waist
      t.string :seat
      t.string :thigh
      t.string :knee
      t.string :bottom
      t.text :remarks

      t.timestamps
    end
  end
end
