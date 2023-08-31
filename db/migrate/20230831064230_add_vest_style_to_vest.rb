class AddVestStyleToVest < ActiveRecord::Migration[7.0]
  def change
    add_column :vests, :vest_style, :integer, default: 0, null: false
  end
end
