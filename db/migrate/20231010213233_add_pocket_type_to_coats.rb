class AddPocketTypeToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :pocket_type, :integer, default: 0, null: false
  end
end
