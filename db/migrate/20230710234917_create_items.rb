class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.integer :order_id
      t.string :name
      t.integer :quantity
      t.string :fabric_and_linning_code

      t.timestamps
    end
  end
end
