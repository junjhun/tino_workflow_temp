class AddPurposeToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :purpose, :string
    add_column :orders, :MTO_labor, :integer
  end
end
