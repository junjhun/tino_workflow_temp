class RenameHeardFromSourceToHeardFrom < ActiveRecord::Migration[7.0]
  def change
    rename_column :clients, :heard_from_source, :heard_from
    change_column :clients, :heard_from, :integer, default: 4, null: false
  end
end
