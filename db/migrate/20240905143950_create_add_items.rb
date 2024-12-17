class CreateAddItems < ActiveRecord::Migration[7.0]
  def change
    create_table :add_items do |t|
      t.integer :item_type

    end
  end
end
