class AddPantCuffsToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :pant_cuffs, :integer, default: 0, null: false
    add_column :pants, :strap, :integer, default: 0, null: false
    add_column :pants, :add_suspender_buttons, :boolean, default: 0, null: false
  end
end
