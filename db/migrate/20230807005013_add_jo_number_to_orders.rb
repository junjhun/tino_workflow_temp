class AddJoNumberToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :jo_number, :string
  end
end
