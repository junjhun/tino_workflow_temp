class AddFittingToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :first_fitting, :date
    add_column :orders, :second_fitting, :date
    add_column :orders, :finish, :date
  end
end
