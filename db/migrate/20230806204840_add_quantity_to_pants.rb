class AddQuantityToPants < ActiveRecord::Migration[7.0]
  def change
    add_column :pants, :quantity, :integer, null: false, default: 0
    add_column :pants, :fabric_code, :string
    add_column :pants, :lining_code, :string
  end
end
