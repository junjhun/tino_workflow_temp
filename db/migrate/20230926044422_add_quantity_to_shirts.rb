class AddQuantityToShirts < ActiveRecord::Migration[7.0]
  def change
    add_column :shirts, :quantity, :integer, default: 0, null: false
    add_column :vests, :quantity, :integer, default: 0, null: false
  end
end
