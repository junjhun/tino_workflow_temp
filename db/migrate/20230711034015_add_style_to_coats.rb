class AddStyleToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :fabric_code, :string
    add_column :coats, :lining_code, :string
    add_column :coats, :style, :integer
    add_column :coats, :collar_style, :integer
    add_column :coats, :back, :integer
    add_column :coats, :lining, :integer
    add_column :coats, :sleeves_and_padding, :integer
    add_column :coats, :button, :integer
    add_column :coats, :sleeve_buttons, :integer
    add_column :coats, :boutonniere, :integer
    add_column :coats, :boutonniere_color, :string
    add_column :coats, :boutonniere_thread_code, :string
    add_column :coats, :button_spacing, :integer
    add_column :coats, :shoulder_pocket, :integer
    add_column :coats, :coat_pockets, :integer
  end
end
