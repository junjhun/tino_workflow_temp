class AddBrandNameToOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :orders, :other_brands
    add_column :orders, :brand_name, :integer
  end
end
