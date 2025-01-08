class AddColumnsInOrders < ActiveRecord::Migration[7.0]
  def change
    # remove_column :orders, :purpose
    # add_column :orders, :purpose, :integer, default: 0, null: false
    add_column :orders, :jacket_length, :string
    add_column :orders, :back_width, :string
    add_column :orders, :sleeves, :string
    add_column :orders, :cuffs_1, :string
    add_column :orders, :cuffs_2, :string
    add_column :orders, :collar, :string
    add_column :orders, :chest, :string
    add_column :orders, :waist, :string
    add_column :orders, :hips, :string
    add_column :orders, :stature, :string
    add_column :orders, :shoulders, :string
  end
end
