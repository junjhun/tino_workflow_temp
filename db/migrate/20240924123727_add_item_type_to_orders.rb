class AddItemTypeToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :item_type, :string
  end
end
