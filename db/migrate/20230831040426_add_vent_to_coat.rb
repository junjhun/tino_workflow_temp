class AddVentToCoat < ActiveRecord::Migration[7.0]
  def change
    remove_column :coats, :back
    remove_column :coats, :vent
    add_column :coats, :vent, :integer, default: 0, null: false
  end
end
