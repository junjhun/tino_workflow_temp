class AddMissingShirtColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :right_cuff, :string
    add_column :shirts, :left_cuff, :string
    add_column :shirts, :chest, :string
    add_column :shirts, :shirt_waist, :string
    add_column :shirts, :stature, :string
    add_column :shirts, :shoulders, :string
    add_column :shirts, :opening, :integer
    add_column :shirts, :no_of_studs, :integer
    add_column :shirts, :front_pleats, :integer
    add_column :shirts, :back_pleats, :integer
    add_column :shirts, :with_flap, :boolean, default: false
    add_column :shirts, :front_pocket_flap, :integer
    add_column :shirts, :sleeve_length, :integer
    add_column :shirts, :buttoned_down, :boolean, default: false
    add_column :shirts, :buttoned_down_with_loop, :boolean, default: false
    add_column :shirts, :contrast_placement, :string
    add_column :shirts, :monogram_initials, :string
    add_column :shirts, :monogram_placement, :integer
    add_column :shirts, :monogram_font, :integer
    add_column :shirts, :monogram_color, :string
    add_column :shirts, :monogram_thread_code, :string
  end
end
