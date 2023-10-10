class AddFrontSidePocketToChest < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :front_side_pocket, :integer, default: 0, null: false
  end
end
