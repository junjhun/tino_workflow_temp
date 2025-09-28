class RemoveColumnsFromOrders < ActiveRecord::Migration[7.0]
  def change
    # Ensure the column exists before removing it
    return unless column_exists?(:orders, :third_fitting)

    remove_column :orders, :third_fitting, :datetime
  end
end
