class AddQuantityToCoats < ActiveRecord::Migration[7.0]
  def change
    add_column :coats, :quantity, :integer, null: false, default: 0
  end
end
