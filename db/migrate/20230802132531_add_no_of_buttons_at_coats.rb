class AddNoOfButtonsAtCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :no_of_buttons, :string
  end
end
