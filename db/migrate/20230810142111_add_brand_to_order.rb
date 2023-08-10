class AddBrandToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :other_brands, :string
  end
end
