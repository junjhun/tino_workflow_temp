class AddShirtingBarongToShirts < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :number_of_buttons, :integer, default: 0, null: false
    add_column :shirts, :shirting_barong, :integer, default: 0, null: false
  end
end
