class UpdateCoatsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :lapel_width, :string
    add_column :coats, :color_of_sleeve_buttons, :string
    add_column :coats, :flower_holder, :boolean, default: false
    add_column :coats, :lapel_buttonhole_thread_color, :string
    add_column :coats, :chest_pocket_satin, :boolean, default: false
    add_column :coats, :side_pockets_flap, :boolean, default: false
    add_column :coats, :side_pockets_satin, :boolean, default: false
    add_column :coats, :side_pockets_ticket, :boolean, default: false
    add_column :coats, :side_pocket_placement, :integer
    add_column :coats, :monogram_initials, :string
    add_column :coats, :monogram_placement, :integer
    add_column :coats, :monogram_font, :integer
    add_column :coats, :monogram_thread_color, :string
  end
end
