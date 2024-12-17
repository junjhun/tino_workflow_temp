class AddColumnsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :third_fitting, :date
    add_column :orders, :fourth_fitting, :date
  end
end
