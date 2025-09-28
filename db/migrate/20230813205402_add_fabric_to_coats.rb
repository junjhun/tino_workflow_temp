class AddFabricToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :fabric_label, :string
    add_column :coats, :tafetta, :string
    add_column :coats, :brand_label, :string
  end
end
