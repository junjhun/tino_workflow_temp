class AddFabricToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :fabric_label, :string
    add_column :pants, :tafetta, :string
    add_column :pants, :brand_label, :string
  end
end
