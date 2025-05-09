class AddLapelSatinToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :lapel_satin, :boolean, default: false
  end
end