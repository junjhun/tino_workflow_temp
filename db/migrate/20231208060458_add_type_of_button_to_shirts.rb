class AddTypeOfButtonToShirts < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :type_of_button, :integer, default: 0, null: false
  end
end
