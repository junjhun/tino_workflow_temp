class RenameCollarToCollarStyleAndAddCollarToShirts < ActiveRecord::Migration[7.0]
  def change
    rename_column :shirts, :collar, :collar_style

    add_column :shirts, :collar, :string
  end
end
