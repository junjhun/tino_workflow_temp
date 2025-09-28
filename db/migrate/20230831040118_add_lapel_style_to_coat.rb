class AddLapelStyleToCoat < ActiveRecord::Migration[7.0]
  def change
    remove_column :coats, :collar_style
    add_column :coats, :lapel_style, :integer, default: 0, null: false
  end
end
