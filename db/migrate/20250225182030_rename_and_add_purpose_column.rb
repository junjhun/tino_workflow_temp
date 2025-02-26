class RenameAndAddPurposeColumn < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :purpose, :purpose_old
    add_column :orders, :purpose, :integer, default: 0, null: false
  end
end
