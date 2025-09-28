class AddMissingFieldsToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :rise, :integer
    add_column :pants, :cut, :integer
    add_column :pants, :overlap, :integer
    add_column :pants, :waistband_thickness, :string
    add_column :pants, :tightening, :integer
    add_column :pants, :closure, :integer
    add_column :pants, :crotch_saddle, :boolean, default: false
    add_column :pants, :front_pocket, :integer
    add_column :pants, :coin_pocket, :boolean, default: false
    add_column :pants, :flap_on_coin_pocket, :boolean, default: false
    add_column :pants, :flap_on_jetted_pocket, :boolean, default: false
    add_column :pants, :buttons_on_jetted_pockets, :boolean, default: false
    add_column :pants, :button_loops_on_jetted_pockets, :boolean, default: false
    add_column :pants, :satin_trim, :boolean, default: false
    add_column :pants, :cuff_on_hem, :boolean, default: false
    add_column :pants, :width_of_cuff, :string
  end
end
