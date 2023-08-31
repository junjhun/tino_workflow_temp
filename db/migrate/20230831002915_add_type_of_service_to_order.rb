class AddTypeOfServiceToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :type_of_service, :integer, default: 0, null: false
    remove_column :orders, :MTO_labor, :integer
  end
end
