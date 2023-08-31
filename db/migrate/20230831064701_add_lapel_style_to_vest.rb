class AddLapelStyleToVest < ActiveRecord::Migration[7.0]
  def change
    add_column :vests, :remarks, :text
    add_column :vests, :number_of_front_buttons, :string
    add_column :vests, :lapel_style, :integer, default: 0, null: false
    add_column :vests, :adjuster_type, :integer, default: 0, null: false
  end
end
